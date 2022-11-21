@echo off
rem 
rem @author Tyler R. Drury
rem @date 10-11-2022
rem @copyright Tyler R. Drury, All Rights Reserved
rem @brief VSN SSF32 CLI batch file for automated genertion of project SSF32 signtures
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
rem ssf32Dir.bat command line arguments
rem 
rem --q quiet-mode, supresses all output (except final program result)
rem --v verbose output
rem --d debug mode
rem --h help mode
rem 
rem --hex output hex encoded string, mutually exclusive with --base64 flag
rem --base64 output base64 encoded string, mutually exclusive with --hex flag
rem 
rem --pad pad encoded output to 32 byte boundaries
rem --chunk chunk encode output in compliance with RCF-2045
rem --compress gzdeflate result before outputing
rem 
rem goto :dealloc

if not defined VS_BANNER (
    rem setx "VS_BANNER=---~~--~-~-~~~-~--~~~-~~-~~~~~~~---~~--~-~-~~~-~--~~~-~~-~~~~~~~"
    set VS_BANNER=---~~--~-~-~~~-~--~~~-~~-~~~~~~~---~~--~-~-~~~-~--~~~-~~-~~~~~~~
)
rem line separator
if not defined VS_SEP (
    rem setx "VS_SEP=---~"
    set VS_SEP=---~
)
rem if not defined VSN_GLOBAL_PHARS_DIR (
rem     set "GLOBAL_PHARS_DIR=C:/phars"
rem )
if not defined VSN_SSF_CLI_PHP56_DIR (
    set "VSN_SSF_CLI_PHP56_DIR=%GLOBAL_PHARS_DIR%/ssf-cli-php56"
)
rem 
if not defined XT ( set "XT=.log" )
rem if not defined  XT_LOG ( set "XT_LOG=.log" )
rem if not defined  XT_GZ ( set "XT_GZ=.gz" )
if not defined XT_JSON set "XT_JSON=.json"
rem if not defined XT_XML ( set "JSON_XT=.xml" )
rem 
rem if not defined XT_SSF32 ( set "JSON_XT=.ssf32" )
rem if not defined XT_SSF64 ( set "JSON_XT=.ssf64" )
rem 
rem if not defined XT_HEX_SSF32 ( set "XT_HEX_SSF32=.hex.%XT_SSF32%" )
rem if not defined XT_BASE64_SSF32 ( set "JSON_XT=.base64.%XT_SSF64%" )
rem 
rem if not defined XT_HEX_SSF64 ( set "XT_HEX_SSF64=.hex.%XT_SSF64%" )
rem if not defined XT_BASE64_SSF64 ( set "JSON_XT=.base64.%XT_SSF64%" )
rem 
if not defined XT_PHP set "XT_PHP=.php"
rem if not defined XT_JPG (
rem     set "XT_JPG=.jpg"
rem )
rem if not defined XT_PNG (
rem     set "XT_PNG=.png"
rem )
rem if not defined XT_H (
rem     set "XT_H=.h"
rem )
rem if not defined XT_CPP (
rem     set "XT_CPP=.cpp"
rem )
rem if not defined XT_PY (
rem     set "XT_PY=.py"
rem )
rem if not defined XT_JS = (
rem     set "XT_JS=.js"
rem )
rem if not defined XT_MD = (
rem     set "XT_JS=.md"
rem )
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
)
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
) else if "%~1"=="--ssf64" (
    if not defined _SSF64 ( set "_SSF64=--ssf64" )
) else if "%~1"=="--chunk" (
    if not defined _CHUNK ( set "_CHUNK=--chunk" )
) else if "%~1"=="--compress" (
    if not defined _COMPRESS ( set "_COMPRESS=--compress" )
) else if "%~1"=="--x" (
    goto :parseExtension
)
shift
goto :loop
rem 
rem  else if "%~1"=="--ia" (
rem     if not defined _IAM ( set "_IAM=--A" )
rem ) else if "%~1"=="--ce" (
rem     if not defined _CEM ( set "_CEM=--C" )
rem 
:parseExtension
rem echo %~1
shift
rem echo %2
rem echo %*
rem 
if "%1"=="" (
    set /P _CLI_EXT=Please enter a file extension,
    goto :continue
)
rem FOR /F "tokens = 1 delims = \ " %%A IN ( 'ECHO.%~1' ) do SET SRC=%%A
if not defined _CLI_EXT (
    set "_CLI_EXT=%~1"
    rem =.*:
)
shift
goto :loop
rem else if "%1"=="--_CLI_EXT" (
rem     goto :parseExtension
rem )
rem else if "%1"=="--pk" (
rem     shift
rem     if "%~1"=="" (
rem         set /P RSA_PRIVATE_KEY_FILE=Please enter your private key path:
rem     ) else (
rem         if not defined RSA_PRIVATE_KEY_FILE (
rem             set "RSA_PRIVATE_KEY_FILE=..."
rem         )
rem     )
rem )
rem @note if neither --hex nor --base64 flag are specified, both encodings will be output
rem 
rem else if "%1"=="--S" (
rem     if defined _U ( exit /B 1 )
rem     if not defined _S ( set _S=--g )
rem )
rem 
rem 
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
rem echo %1
rem 
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
rem input directory, relative to the executing directory or absolute
rem 
rem if not defined ID (
rem    set /P ID=Please enter directory path:
rem ) 
rem 
if not defined _CLI_EXT (
    set /P _CLI_EXT=Please enter a file extension:
) 
rem 
rem set "BUILD_DIR=%cd%\build"
rem set "SRC_DIR=%cd%\_src"
rem 
if not defined OD (
    set "OD=%cd%\_output\ssf32"
) 

if not defined PACKED_UNSIGNED_OD (
    set "PACKED_UNSIGNED_OD=%OD%\packedUnsigned\cdAll"
)
rem input directory containing .txt, .json or .xml command files used for processing cli commands from markup, relative to the executing directory or absolute, relative to the executing directory or absolute
rem set ID=_input
set "ID=%cd%"
rem 
rem set FP_LFP=%OD%\hex\files%XT%
rem set SRC_LFP=%OD%\hex\sources%XT%
rem 
set "LFP=%OD%\cdAllssf32HexBat%XT%"
rem 
rem if not defined _E (
rem ) else if not defined _PAD (
rem ) else (
rem )
rem 
rem packed
rem 
set "PACKED_UNSIGNED_HEX_LFP=%PACKED_UNSIGNED_OD%\ssf32Hex%XT%"
rem 
rem 
rem JSON FILE PATHS
rem 
rem packed
rem 
set "PACKED_UNSIGNED_HEX_JSON_FP=%PACKED_UNSIGNED_OD%\ssf32Hex%XT_JSON%"
rem 
rem 
rem Log File constants
rem
set LF_PACKED_UNSIGNED_HEX=%PACKED_UNSIGNED_HEX_LFP% 2>&1
rem set LFP=%OD%\base64%XT%
set LF=%LFP% 2>&1
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
if not defined _QUIET ( call :truncLog %LFP% )
rem 
rem echo %GLOBAL_PHARS_DIR%
rem 
rem 
rem exit /B %ERRORLEVEL%
rem 
rem 
rem Make output directories if they do not exists
rem 
call :mkDirIfNotExists "%OD%" "%LFP%"
call :mkDirIfNotExists "PACKED_UNSIGNED_OD" "%LFP%"
rem 
rem exit /B %ERRORLEVEL%
rem 
rem 
rem 
rem goto dealloc
rem 
rem OpenSSL variables
rem 
rem )
rem set PUBLIC_KEY_FILE=C:\xampp\htdocs\_crts\vsKey.pub
rem get password provided by stdin
rem 
rem if not defined _CLI_EXT (
rem     set /P _CLI_EXT=.php
rem     rem Please enter a file extension for filtering files, 
rem ) 
rem if not defined PKP (
rem if defined RSA_PRIVATE_KEY_FILE (
rem set RSA_PRIVATE_KEY_FILE=C:\xampp\htdocs\_crts\VS.key
rem )
rem else (
rem set /P PKP=Please enter a local path to your private key, 
rem )
rem ) 
rem if COMPRESS (
rem     set "OFP=%PACKED_SIGNED_OD%/tmp.gz.hex.ssf32"
rem )
rem if not defined OFP (
rem     rem set "OFP=%PACKED_SIGNED_OD%/tmp.hex.ssf32"
rem     set /P OFP=Please enter the fully qualified or relative file path to write to 
rem )
rem 
rem if not defined INPUT_EXT (
rem     set /P INPUT_EXT=Please enter file extension to filter
rem )
rem 
call :truncLog %PACKED_UNSIGNED_HEX_LFP%

if defined _D (
    if not defined _QUIET (
        echo SSF encode directory, packed unsigned hex >> %LF_PACKED_UNSIGNED_HEX%
        echo %VS_SEP% >> %LF_PACKED_UNSIGNED_HEX%
        rem echo to: "%PACKED_SIGNED_HEX_LFP%" >> %LF_PACKED_SIGNED_HEX%
        echo %VS_SEP% >> %LF_PACKED_UNSIGNED_HEX%
    )
)
rem echo %VS_BANNER% > %PACKED_SIGNED_OD%\base64.log 2>&1
rem )
rem %php5% %VSN_SSF_CLI_PHP56_DIR%/run%XT_PHP% --M=encode --F=directory --source="%BUILD_DIR%" --O=%PACKED_UNSIGNED_HEX_LFP% --hex

rem echo %cd%
rem call ssf32DirHex.bat "%BUILD_DIR%"
rem call :ssf32DirPackedUnsignedHex "%BUILD_DIR%" "%PACKED_UNSIGNED_HEX_LFP%" "%PACKED_UNSIGNED_OD%\ssf32CDAllPHP_hex.log"
rem %_CLI_EXT%
for /R %cd% %%f in (
    %_CLI_EXT%
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
    rem     %php5% -f %PHAR_DIR%/ssf-cli-php56/run%XT_PHP% -c php.ini -- %FLAGS%>> %LF%
    rem ) else (
    rem     %php5% -f %PHAR_DIR%/ssf-cli-php56/run%XT_PHP% -c php.ini>> %LF%
    rem echo %%f
    rem %php5% -f %VSN_SSF_CLI_PHP56_DIR%/run%XT_PHP% -- --M=encode --F=f --source=%%f --hex --v --d=3
    
    rem echo %VS_SEP%>> %LF%
    rem )
    echo %%f ssf32 = >> %LF_PACKED_UNSIGNED_HEX%
    %php5% %VSN_SSF_CLI_PHP56_DIR%/run%XT_PHP% --M=encode --F=fts --source=%%f --hex >> %LF_PACKED_UNSIGNED_HEX%
    echo; >> %LF_PACKED_UNSIGNED_HEX%
    echo %VS_SEP% >> %LF_PACKED_UNSIGNED_HEX%
    rem %php5% %VSN_SSF_CLI_PHP56_DIR%/run%XT_PHP% --M=encode --F=fts --source=%%f --privateKey=%PKP% --password="%PKPW%" --base64 >> %LF_PACKED_SIGNED_BASE64%
    if %ERRORLEVEL% NEQ 0 (
        if defined _D (
            if not defined _QUIET (
                echo Terminating script with error %ERRORLEVEL% >> %LF_PACKED_UNSIGNED_HEX%
                echo %VS_SEP% >> %LF_PACKED_UNSIGNED_HEX%
            )
        )
        goto dealloc
    )
)
rem 
rem set SSF_OUTPUT_DIR=C:/phars/ssf-cli-php56/_output/ssf32
rem 
rem if not exist "%SSF_OUTPUT_DIR%\" (
rem     if defined _D (
rem         echo %VS_BANNER%>> %LF%
rem         echo directory does not exist at "%SSF_OUTPUT_DIR%">> %LF%
rem     )
rem     goto dealloc
rem )
rem 
if not exist "%OD%\" (
    if defined _D (
        if not defined _QUIET (
            echo %VS_BANNER% >> %LF%
            echo output directory does not exist at "%OD%" >> %LF%
        )
    )
    goto dealloc
)
rem 
rem if defined %_COPY% (
rem     robocopy "%OD%" "%SSF_OUTPUT_DIR%" /e /mt>> %LF%
rem     if %ERRORLEVEL% NEQ 0 goto dealloc
rem )
rem 
rem for /R _src\ %%f in (

rem if defined _D ( echo %VS_BANNER%>> %LF% )
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
set XT_JSON=
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
:mkDirIfNotExists
echo "%~1" >> %~2
if not exist "%~1\\" (
    if defined _D (
        echo %VS_SEP% >> %~2
        echo making directory: %~1 >> %~2
    )
    mkdir %~1
)
exit /b
rem
:truncLog
echo %VS_BANNER% > %1 2>&1
echo @author Tyler R. Drury (vigilance.eth) >> %~1 2>&1
echo @date 10-11-2022 >> %~1 2>&1
echo @copyright Tyler R. Drury, All Rights Reserved >> %~1 2>&1
echo @created %DATE% @ %TIME% >> %~1 2>&1
echo %VS_SEP% >> %~1 2>&1
exit /b
rem 