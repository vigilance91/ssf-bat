@echo off
rem 
rem @author Tyler R. Drury
rem @date 10-11-2022
rem @copyright Tyler R. Drury, All Rights Reserved
rem @brief VSN CHRONO CLI batch file for automated genertion of project SSF32 signtures
rem @note do NOT include in repo or production builds
rem 
rem @note this (and all other related batch files in _scripts) accepts arguments --q, --h, --v, --d and passes them onto all executed php scripts
rem 
rem windows return codes
rem 0 success
rem 1 incorrect function has attempted to execute (not recognized op)
rem 2 system can not find a file in a specified location
rem 3 system can not find specified path
rem 5 access denied, use has no right to resource (use with authentication cli apps)
rem 0x2331 program not recognized as internal or external command, operable program or batch file
rem 0xC0000005 access violation(program terminated abnormally or crashed)
rem 0xC000013A terminated due to CTRL + C or CTRL + break
rem 0xC0000142 application failed to terminate properly
rem 
rem ssf32.bat command line arguments
rem 
rem --q quiet-mode, supresses all output (except final program result)
rem --v verbose output
rem --d debug mode
rem --h help mode
rem --hex output hex encoded string, mutually exclusive with --base64 flag
rem --base64 output base64 encoded string, mutually exclusive with --hex flag
rem 
if not defined VS_BANNER (
    rem setx "VS_BANNER=---~~--~-~-~~~-~--~~~-~~-~~~~~~~---~~--~-~-~~~-~--~~~-~~-~~~~~~~"
    set VS_BANNER=---~~--~-~-~~~-~--~~~-~~-~~~~~~~---~~--~-~-~~~-~--~~~-~~-~~~~~~~
)
rem line separator
if not defined VS_SEP (
    rem setx "VS_SEP=---~"
    set VS_SEP=---~
)

if not defined VSN_SSF_CLI_PHP56_DIR (
    set "VSN_SSF_CLI_PHP56_DIR=%GLOBAL_PHARS_DIR%/ssf-cli-php56"
)
rem 
setlocal ENABLEEXTENSIONS
REM chronoPHP API tests, executing PHP scripts via Windows .bat file!
rem yeah automation!
REM
REM (>) is used to write to a file, truncating any current contents
REM (>>) is used to append to a file
rem list all regular (static) variables for the current session
rem set /?
rem
rem echo %_D%
rem echo %F_DBG%
rem echo %HELP%
rem echo %VERB%
rem 
:loop
if "%1"=="" (
    rem echo continuing with script execution
    goto continue
) else (
    rem echo %1
    if "%1"=="--d" (
        rem echo pre-shift %1
        rem shift
        rem echo post-shift %1
        rem rem set dl=%1
        rem if "%1"=="" (
        rem     rem if debug mode is enabled, expected value to be in range [0,4]
        rem     echo no debug flag set, epectected value betwenn [0,4], includsive
        rem     exit /B -1
        rem )
        rem echo %1
        rem ) else if if "%1"=="5" (
        if not defined _D (
            rem echo setting _D flag
            rem if "%1"=="0" (
                rem set F_DBG=--d=0
            rem ) else if "%1"=="1" (
                rem set F_DBG=--d=1
            rem ) else if "%1"=="2" (
                rem set F_DBG=--d=2
            rem ) else if "%1"=="3" (
                set _D=--d=3
            rem ) else if "%1"=="4" (
                rem set F_DBG=--d=4
            rem ) else (
            rem echo %_D%    
            rem )
            
            rem echo from command line args
        ) 
        rem 
        rem echo %_D%
    ) else if "%~1"=="--v" (
        if not defined VERB ( set "VERB=--v" )
    ) else if "%~1"=="--h" (
        if not defined HELP ( set "HELP=--h" )
    ) else if "%~1"=="--q" (
        if not defined _QUIET ( set "_QUIET=--q" )
    ) else if "%~1"=="--ia" (
        if not defined _IAM ( set "_IAM=--A" )
    ) else if "%~1"=="--ce" (
        if not defined _CEM ( set "_CEM=--C" )
    ) else if "%~1"=="--ssf64" (
        if not defined _SSF64 ( set "_SSF64=--ssf64" )
    ) else if "%~1"=="--pad" (
        if not defined _PAD ( set "_PAD=--pad" )
    ) else if "%~1"=="--chunk" (
        if not defined _CHUNK ( set "_CHUNK=--chunk" )
    ) else if "%~1"=="--compress" (
        if not defined _COMPRESS ( set "_COMPRESS=--compress" )
    ) else if "%1"=="--pw" (
        shift
        if "%~1"=="" (
            set /P UPW=Please enter your private key password:
        ) else (
            set UPW=%~1
        )
    )
    rem else if "%1"=="--pk" (
    rem     shift
    rem     if "%~1"=="" (
    rem         set /P RSA_PRIVATE_KEY_FILE=Please enter your local private key path:
    rem     ) else (
    rem         if not defined RSA_PRIVATE_KEY_FILE (
    rem             set "RSA_PRIVATE_KEY_FILE=..."
    rem         )
    rem         if not exist %RSA_PRIVATE_KEY_FILE% ( exit /B 1 )
    rem     )
    rem )
    rem @note if neither --hex nor --base64 flag are specified, both encodings will be output
    rem 
    rem else if "%1"=="--S" (
    rem     if defined _U ( exit /B 1 )
    rem     if not defined _S ( set _S=--g )
    rem )
    rem 
    rem if defined D ( set D=)
    rem if defined VERB ( set VERB= )
    rem if defined HELP ( set HELP= )
    rem if defined FLAGS ( set FLAGS= )
    rem 
    rem else if "%1"=="--od" (
        rem shift
        rem if not defined OD (
            rem set OD="%1"
        rem ) 
    rem ) 
) 
rem echo %1
shift
goto loop
rem 
:continue
rem 
rem exit /B %ERRORLEVEL%
rem set _ER_LEVEL=3
rem if defined _D (
rem     echo debug flag: %_D%
rem )
rem if defined VERB (
rem     echo verbose flag: %VERB%
rem )
rem if defined HELP (
rem     echo help flag: %HELP%
rem )
rem if defined FLAGS ( set FLAGS= )
rem 
rem if not defined QUIET (
if defined HELP (
    if defined VERB (
        if defined _D (
            set FLAGS=%_D% %HELP% %VERB%
        ) else (
            set FLAGS=%HELP% %VERB%
        )
    ) else (
        if defined _D (
            set FLAGS=%_D% %HELP%
        ) else (
            set FLAGS=%HELP%
        )
    )
) else if defined VERB (
    if defined _D (
        set FLAGS=%_D% %VERB%
    ) else (
        set FLAGS=%VERB%
    )
) else if defined _D ( set FLAGS=%_D% )
rem 
rem exit /B %ERRORLEVEL%
rem 
rem ) else ( set FLAGS=%QUIET% )
rem 
rem echo ----
rem echo %*
rem echo ----
rem 
set "XT=.log"
set "JSON_XT=.json"
rem output directory, relative to the executing directory or absolute
rem 
set "BUILD_DIR=%cd%\build"
set "SRC_DIR=%cd%\_src"
rem set SCRIPTS_DIR=%~dp0\_scripts
rem set TEST_DIR=%~dp0\_tests
rem 

if not defined OD (
    set "OD=%cd%\_output\ssf32"
) 

if not defined PACKED_UNSIGNED_OD (
    set "PACKED_UNSIGNED_OD=%OD%\packedUnsigned"
)
if not defined PACKED_SIGNED_OD (
    set "PACKED_SIGNED_OD=%OD%\packedSigned"
)
if not defined PADDED_UNSIGNED_OD (
    set "PADDED_UNSIGNED_OD=%OD%\paddedUnsigned"
)
if not defined PADDED_SIGNED_OD (
    set "PADDED_SIGNED_OD=%OD%\paddedSigned"
)
rem input directory containing .txt, .json or .xml command files used for processing cli commands from markup, relative to the executing directory or absolute, relative to the executing directory or absolute
rem set ID=_input
set "ID=%cd%\_src"
rem 
rem set FP_LFP=%OD%\hex\files%XT%
rem set SRC_LFP=%OD%\hex\sources%XT%
rem 
set "LFP=%OD%\ssf32Base64Bat%XT%"
rem 
rem if not defined _E (
rem ) else if not defined _PAD (
rem ) else (
rem )
set LF=%LFP% 2>&1
rem
rem LOG FILE OUTPUT PATHS
rem 
rem packed
rem 
set "PACKED_UNSIGNED_LFP=%PACKED_UNSIGNED_OD%\base64%XT%"
set "PACKED_SIGNED_LFP=%PACKED_SIGNED_OD%\base64%XT%"
rem 
rem padded
rem 
set "PADDED_UNSIGNED_LFP=%PADDED_UNSIGNED_OD%\base64%XT%"
set "PADDED_SIGNED_LFP=%PADDED_SIGNED_OD%\base64%XT%"
rem 
rem OUTPUT LOG TO FILE
rem 
set LF_PACKED_UNSIGNED=%PACKED_UNSIGNED_LFP% 2>&1
set LF_PACKED_SIGNED=%PACKED_SIGNED_LFP% 2>&1
rem 
set LF_PADDED_UNSIGNED=%PADDED_UNSIGNED_LFP% 2>&1
set LF_PADDED_SIGNED=%PADDED_SIGNED_LFP% 2>&1
rem 
rem JSON OUTPUT PATHS
rem 
rem packed
rem 
set "PACKED_UNSIGNED_JSON_FP=%PACKED_UNSIGNED_OD%\base64%JSON_XT%"
set "PACKED_SIGNED_JSON_FP=%PACKED_SIGNED_OD%\base64%JSON_XT%"
rem 
rem padded
rem 
set "PADDED_UNSIGNED_JSON_FP=%PADDED_UNSIGNED_OD%\base64%JSON_XT%"
set "PADDED_SIGNED_JSON_FP=%PADDED_SIGNED_OD%\base64%JSON_XT%"
rem 
rem OUTPUT JSON TO FILE
rem 
rem set OUTPUT_JSON_PACKED_UNSIGNED=%PACKED_UNSIGNED_JSON_FP% 2>&1
rem set OUTPUT_JSON_PACKED_SIGNED=%PACKED_SIGNED_JSON_FP% 2>&1
rem 
rem set OUTPUT_JSON_PADDED_UNSIGNED=%PADDED_UNSIGNED_JSON_FP% 2>&1
rem set OUTPUT_JSON_PADDED_SIGNED=%PADDED_SIGNED_JSON_FP% 2>&1
rem 

rem this path includes triling slash
rem echo %~dp0 >> %LF%
rem this pth DOES NOT includes triling slash
rem echo %cd% >> %LF%
rem  else if defined F_DBG (
rem    set FLAGS=%F_DBG%=3
rem )
rem 
if defined FLAGS (
    echo cli arguments: %FLAGS% >> %LF%
) else (
    rem 
)
rem if not defined SSF_CLI_PHP56 (
rem     set SSF_CLI_PHP56=%GLOBAL_PHARS_DIR%/ssf-cli-php56
rem )
rem truncate log file
rem 
rem 
rem Make output directories if they do not exists
rem 
call :mkDirIfNotExists "%OD%"
rem 
rem exit /B %ERRORLEVEL%
rem 
call :mkDirIfNotExists "%PACKED_UNSIGNED_OD%"
call :mkDirIfNotExists "%PACKED_SIGNED_OD%"
rem 
call :mkDirIfNotExists "%PADDED_UNSIGNED_OD%"
call :mkDirIfNotExists "%PADDED_SIGNED_OD%"
rem 
rem goto dealloc
rem 
rem :truncLog
call :truncLog %LFP%
rem 
rem echo %VS_BANNER% > %LF%
rem echo @author Tyler R. Drury >> %LF%
rem echo @date 10-11-2022 >> %LF%
rem echo @copyright Tyler R. Drury, All Rights Reserved >> %LF%
rem echo @created %DATE% @ %TIME% >> %LF%
rem echo @brief VSN (C)(TM) CHRONO-CLI-PHP SSF32BASE64.BAT >> %LF%
rem echo %VS_SEP% >> %LF%
rem 
rem echo %GLOBAL_PHARS_DIR%
rem 
rem 
rem exit /B %ERRORLEVEL%
rem 
rem OpenSSL variables
rem 
rem if not defined RSA_PRIVATE_KEY_FILE (
rem     set /P RSA_PRIVATE_KEY_FILE=Please enter your private key path:
rem )
set RSA_PRIVATE_KEY_FILE=C:\xampp\htdocs\_crts\VS.key
rem )
rem set PUBLIC_KEY_FILE=C:\xampp\htdocs\_crts\vsKey.pub
rem get password provided by stdin

if not defined UPW (
    set /P UPW=Please enter your private key password:
) 
rem 
rem exit /B %ERRORLEVEL%
rem 
if not defined _PAD (
    rem 
    rem 
    call :truncLog %PACKED_UNSIGNED_LFP%
    call :truncLog %PACKED_SIGNED_LFP%
    rem with source rg explicitly stated:
    rem %php5% %GLOBAL_PHARS_DIR%/ssf-cli-php56/run.php --M=encode --F=directory --source=%cd% --O=%LFP% --hex
    rem the current working directory which this script is executed in will be the directory used implicitly when omittted
    rem )
    call :ssf32DirPackedUnsignedBase64 "%BUILD_DIR%" "%PACKED_UNSIGNED_JSON_FP%" "%PACKED_UNSIGNED_LFP%"
    rem call :terminateIfErrorLevelNotZero %PACKED_UNSIGNED_LFP%
    if %ERRORLEVEL% NEQ 0 (
        rem if defined _D (
        echo Terminating script with error %ERRORLEVEL% >> %LF_PACKED_UNSIGNED%
        echo %VS_SEP% >> %LF_PACKED_UNSIGNED%
        rem )
        goto dealloc
    )
    rem 
    if defined _D (
        echo SSF encode directory, packed signed base64 >> %LF_PACKED_SIGNED%
        echo %VS_SEP% >> %LF_PACKED_SIGNED%
        echo from: "%BUILD_DIR%" >> %LF_PACKED_SIGNED%
        echo to: "%PACKED_SIGNED_JSON_FP%" >> %LF_PACKED_SIGNED%
    )
    %php5% %VSN_SSF_CLI_PHP56_DIR%/run.php --M=encode --F=directory --source="%BUILD_DIR%" --O=%PACKED_SIGNED_JSON_FP% --privateKey=%RSA_PRIVATE_KEY_FILE% --password=%UPW% --base64
    rem call :terminateIfErrorLevelNotZero %PACKED_SIGNED_LFP%
    if %ERRORLEVEL% NEQ 0 (
        rem if defined _D (
        echo Terminating script with error %ERRORLEVEL% >> %LF_PACKED_SIGNED%
        echo %VS_SEP% >> %LF_PACKED_SIGNED%
        rem )
        goto dealloc
    )
    goto dealloc
    rem 
    rem packed signed encoding
    rem 
    rem set SSF32_ENCODE_CWD_PACKED_UNSIGNED=%php5% %GLOBAL_PHARS_DIR%/ssf-cli-php56/run.php --M=encode --F=directory --O=%PACKED_SIGNED_HEX_LFP%
    rem set SSF32_ENCODE_CWD_PACKED_SIGNED=%SSF32_ENCODE_CWD_PACKED_UNSIGNED% --privateKey=%RSA_PRIVATE_KEY_FILE% --password=%UPW%
    rem 
) else if "%_PAD%"=="--pad" (
    rem 
    rem clear base64 log files
    rem 
    call :truncLog %PADDED_UNSIGNED_LFP%
    call :truncLog %PADDED_SIGNED_LFP%
    rem 
    rem padded unsigned base64
    rem 
    call :ssf32DirPaddedUnsignedBase64 "%BUILD_DIR%" "%PADDED_UNSIGNED_JSON_FP%" "%PADDED_UNSIGNED_LFP%"
    rem call :terminateIfErrorLevelNotZero %PADDED_SIGNED_LFP%
    if %ERRORLEVEL% NEQ 0 (
        rem if defined _D (
        echo Terminating script with error %ERRORLEVEL% >> %LF_PADDED_UNSIGNED%
        echo %VS_SEP% >> %LF_PADDED_UNSIGNED%
        rem )
        goto dealloc
    )
    rem 
    rem padded signed base64
    rem 
    if defined _D (
        echo SSF encode directory, padded signed base64 >> %LF_PADDED_SIGNED%
        echo %VS_SEP% >> %LF_PADDED_SIGNED%
        echo from: "%BUILD_DIR%" >> %LF_PADDED_SIGNED%
        echo to: "%PADDED_SIGNED_JSON_FP%" >> %LF_PADDED_SIGNED%
    )
    %php5% %VSN_SSF_CLI_PHP56_DIR%/run.php --M=encode --F=directory --source="%BUILD_DIR%" --O="%PADDED_SIGNED_JSON_FP%" --privateKey=%RSA_PRIVATE_KEY_FILE% --password=%UPW% --pad --base64
    rem call :terminateIfErrorLevelNotZero %...%
    if %ERRORLEVEL% NEQ 0 (
        rem if defined _D (
        echo Terminating script with error %ERRORLEVEL% >> %LF_PADDED_SIGNED%
        echo %VS_SEP% >> %LF_PADDED_SIGNED%
        rem )
        goto dealloc
    )
    goto dealloc
) else (
    rem call :terminateIfErrorLevelNotZero %LF%
    if %ERRORLEVEL% NEQ 0 (
        if defined _D (
            echo %VS_BANNER%>> %LF%
            echo invalid value for flag --pad >> %LF%
            echo %VS_SEP%>> %LF%
            echo terminating script >> %LF%
        )
        goto dealloc
    )
)
rem 
set SSF_OUTPUT_DIR=C:/phars/ssf-cli-php56/_output/ssf32
rem 
if not exist "%SSF_OUTPUT_DIR%\" (
    if defined _D (
        echo %VS_BANNER%>> %LF%
        echo directory does not exist at "%SSF_OUTPUT_DIR%">> %LF%
    )
    goto dealloc
)
rem 
if not exist "%OD%\" (
    if defined _D (
        echo %VS_BANNER%>> %LF%
        echo directory does not exist at "%OD%">> %LF%
    )
    goto dealloc
)
rem 
rem if defined %_COPY% (
rem     robocopy "%OD%" "%SSF_OUTPUT_DIR%" /e /mt>> %LF%
rem     if %ERRORLEVEL% NEQ 0 goto dealloc
rem )
rem 
exit /B %ERRORLEVEL%
rem if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%

rem for /R _src\ %%f in (
:batMain
for /R %~dp0 %%f in (
    *.php
) do (
    rem rewrite stripped code into file. note this is not working!
    rem todo fix
    rem 
    rem %php5% -f %%f -w -n>>%%f 2>&1
    rem 
    rem if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
    rem 
    rem validate transformed script to make sure it has not been corrupted
    rem 
    rem %php5% -f %%f -l -n -e>> %LF%
    rem 
    rem if defined FLAGS (
    rem     %php5% -f %PHAR_DIR%/ssf-cli-php56/run.php -c php.ini -- %FLAGS%>> %LF%
    rem ) else (
    rem     %php5% -f %PHAR_DIR%/ssf-cli-php56/run.php -c php.ini>> %LF%
    rem echo %%f
    rem %php5% -f %GLOBAL_PHARS_DIR%/ssf-cli-php56/run.php -- --M=encode --F=f --source=%%f --hex --v --d=3
    echo %%f ssf32 = >> %LF%
    %php5% %GLOBAL_PHARS_DIR%/ssf-cli-php56/run.php --M=encode --F=fts --source=%%f --base64>> %LF%
    echo:>> %LF%
    rem echo %VS_SEP%>> %LF%
    rem )
    rem if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
    rem 
    rem 
    rem if %ERRORLEVEL% NEQ 0 goto dealloc
    if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
)
if defined _D ( echo %VS_BANNER%>> %LF% )
rem execute _build.php
rem 
rem PHP command line options
rem 
rem -q | --no-headers | quiet-mode, suppress http headers (CGI only)
rem -c | --php-ini | either a directory or a custom php.ini file to use
rem -n | --no-php-ini | ignore php.ini file entirely
rem -T | --timing | measure execution time of script (CGI only)
rem -e | --profile-info | active extended information mode for use by debugger/profiler
rem -f | --file | parse and execute file. if ommited
rem -h | -? | --help | --usage | output list of commands and their descriptions
rem -i | --info | calls phpinfo()
rem -l | --syntax-check | syntax checks file
rem -m | --modules | print built-in and loaded PHP and zend modules
rem -v | --version | PHP version information
rem -w | --strip | remove extraneous whitespace and comments
rem --ini | show configuration file names and scanned directories (CLI only)
rem 
rem if defined _ARGS (
rem %php5% _build.php %_ARGS%
rem ) else (
rem
rem :main
rem if defined _D (
rem %php5% -e -c php.ini -f _build.php --v --d --h>> %LF%
rem ) else (
rem %php5% -e -c php.ini -f _build.php --q>> %LF%
rem 
rem %php5% -f _buildPacked.php -e -c php.ini>> %LF%
rem %php5% -f _buildPadded.php -e -c php.ini>> %LF%
rem 
rem 
rem Unsigned SSF-CLI-PHP
rem 
rem %php5% -f _buildPackedUnsignedHex.php -e -c php.ini>> %LF%
rem %php5% -f _buildPackedUnsignedBase64.php -e -c php.ini>> %LF%
rem 
rem %php5% -f _buildPaddedUnsignedHex.php -e -c php.ini>> %LF%
rem %php5% -f _buildPaddedUnsignedBase64.php -e -c php.ini>> %LF%
rem 
rem Signed SSF-CLI-PHP
rem 
rem %php5% -f _buildPackedSigned.php -e -c php.ini>> %LF%
rem %php5% -f _buildPaddedSigned.php -e -c php.ini>> %LF%
rem 
rem %php5% -f _buildPackedSignedHex.php -e -c php.ini>> %LF%
rem %php5% -f _buildPackedSignedBase64.php -e -c php.ini>> %LF%
rem 
rem %php5% -f _buildPaddedSignedHex.php -e -c php.ini>> %LF%
rem %php5% -f _buildPaddedSignedBase64.php -e -c php.ini>> %LF%
rem )
rem )
rem 
rem if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
rem 
rem run test suite
rem 
rem :tests
rem if defined _t (
rem     cd ../_tests/
rem     call run.bat
rem     cd ../chrono
rem )
rem 
rem dealocate variables declared within this scope,
rem then proceed to terminate script returning the curretn error level
rem
:dealloc
rem 
if defined _D (
    echo %VS_BANNER% >> %LF%
    echo script cleanup >> %LF%
    echo %VS_SEP% >> %LF%
)
rem
if defined _D ( echo removing XT >> %LF% )
set XT=
rem 
if defined _D ( echo removing JSON_EXT >> %LF% )
set JSON_XT=
rem output directory, relative to the executing directory or absolute
rem 
if defined _D ( echo removing BUILD_DIR >> %LF% )
set BUILD_DIR=
rem 
if defined _D ( echo removing SRC_DIR >> %LF% )
set SRC_DIR=
rem unset variables at script shutdown
if defined _D ( echo removing VERB >> %LF% )
set VERB=
rem 
if defined _D ( echo removing HELP >> %LF% )
set HELP=
rem 
if defined _D ( echo removing FLAGS >> %LF% )
set FLAGS=
rem 
if defined _D ( echo removing _G >> %LF% )
set _G=
rem 
if defined _D ( echo removing _E >> %LF% )
set _E=
rem 
if defined _D ( echo removing _CHUNK >> %LF% )
set _CHUNK=
rem 
if defined _D ( echo removing _COMPRESS >> %LF% )
set _COMPRESS=
rem 
if defined _D ( echo removing ID >> %LF% )
set ID=
rem 
if defined _D ( echo removing _CEM >> %LF% )
set _CEM=
rem 
if defined _D ( echo removing _IAM >> %LF% )
set _IAM=
rem 
if defined _D ( echo removing _SSF64 >> %LF% )
set _SSF64=
rem 
if defined _D ( echo removing PACKED_UNSIGNED_OD >> %LF% )
set PACKED_UNSIGNED_OD=
rem 
if defined _D ( echo removing PACKED_SIGNED_OD >> %LF% )
set PACKED_SIGNED_OD=
rem 
if defined _D ( echo removing PADDED_UNSIGNED_OD >> %LF% )
set PADDED_UNSIGNED_OD=
rem 
if defined _D ( echo removing PADDED_SIGNED_OD >> %LF% )
set PADDED_SIGNED_OD=
rem 
set SSF_OUTPUT_DIR=
rem 
rem if %ERRORLEVEL%==0 (
rem     if exist %LFP% ( del %LFP% )
rem )
rem 
rem if defined _D ( echo removing SD >> %LF% )
set SD=
rem 
set LFP=
set LF=
set _QUIET=
rem @note no more logging to logfile after this point!
rem 
rem remove debug flag last, so other entries will be echoed appropriately
set _D=
rem 
rem note: locl variables do not exist after this point
rem 
endlocal
rem
rem if defined VS_BANNER (
rem     rem echo removing VS_BANNER
rem     set VS_BANNER=
rem )
rem rem line separator
rem if defined VS_SEP (
rem     rem echo removing VS_SEP
rem     set VS_SEP=
rem )
rem 
exit /B %ERRORLEVEL%
rem 
rem 
:truncLog
echo %VS_BANNER% > %1 2>&1
echo @author Tyler R. Drury >> %1 2>&1
echo @date 10-11-2022 >> %1 2>&1
echo @copyright Tyler R. Drury, All Rights Reserved >> %1 2>&1
echo @created %DATE% @ %TIME% >> %1 2>&1
echo @brief VSN (C)(TM) CHRONO-CLI-PHP SSF32BASE64.BAT >> %1 2>&1
echo %VS_SEP% >> %1 2>&1
exit /b
rem 
rem :terminateIfErrorLevelNotZero
rem if %ERRORLEVEL% NEQ 0 (
rem     echo Terminating script with error %ERRORLEVEL% >> %1 2>&1
rem     echo %VS_SEP% >> %1 2>&1
rem     
rem     goto dealloc
rem )
rem 
:mkDirIfNotExists
echo "%~1" >> %LF%
if not exist "%~1\\" (
    if defined _D (
        echo %VS_SEP% >> %LF%
        echo making directory: %~1 >> %LF%
    )
    mkdir %~1
)
exit /b
rem 
rem :rmDirIfExists
rem rem echo "%~1" >> %LF%
rem if exist "%~1\\" (
rem     if defined _D (
rem        echo %VS_SEP% >> %LF%
rem        echo removing directory: %~1 >> %LF%
rem     )
rem     rmdir %~1
rem )
rem exit /b
rem 
rem Base64 subroutines
rem 
:ssf32DirPackedUnsignedBase64
if defined _D (
    echo SSF encode directory, packed unsigned base64 >> %~3 2>&1
    echo %VS_SEP% >> %~3 2>&1
    echo src path "%~1" >> %~3 2>&1
    echo dst path "%~2" >> %~3 2>&1
)
%php5% %VSN_SSF_CLI_PHP56_DIR%/run.php --M=encode --F=directory --source="%~1" --O="%~2" --base64
if %ERRORLEVEL% NEQ 0 (
    echo Terminating script with error %ERRORLEVEL% >> %~3 2>&1
    echo %VS_SEP% >> %~3 2>&1
)
exit /b
rem 
:ssf32DirPaddedUnsignedBase64
rem set "logPath=%cd%\_output\ssf32\paddedUnsigned\base64.log"
if defined _D (
    echo SSF encode directory, padded unsigned base64 >> %~3 2>&1
    echo %VS_SEP% >> %~3 2>&1
    echo src path "%~1" >> %~3 2>&1
    echo dst path "%~2" >> %~3 2>&1
)
%php5% %VSN_SSF_CLI_PHP56_DIR%/run.php --M=encode --F=directory --source="%~1" --O="%~2" --base64 --pad
if %ERRORLEVEL% NEQ 0 (
    echo Terminating script with error %ERRORLEVEL% >> %~3 2>&1
    echo %VS_SEP% >> %~3 2>&1
)
exit /b
