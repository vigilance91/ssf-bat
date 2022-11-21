@echo off
rem 
rem @author Tyler R. Drury
rem @date 10-11-2022
rem @copyright Tyler R. Drury, All Rights Reserved
rem @brief VSN SSF32 batch file for automated genertion of project SSF32 Hex signtures
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
rem title "ssf32 - packed unsigned - encode string - base64.bat"
rem color 17
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
rem set "VSN_SSF_CLI_PHP56_EXE=%php5% %VSN_SSF_CLI_PHP56_DIR%/run.php"
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
rem if "%1"=="--d" goto :parseDebugFlag
if "%1"=="--d" (
    rem echo pre-shift %1
    rem shift
    rem echo post-shift %1
    rem rem set dl=%1
    rem if "%1"=="" (
    rem     rem if debug mode is enabled but expected value is not supplied, defult to MAX 4
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
rem ) else if "%~1"=="--rm" (
rem     if not defined REMOVE ( set "REMOVE=--rm" goto :cleanup )
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
) else if "%~1"=="--src" (
    goto :parseSrc
) else if "%~1"=="--pk" (
    goto :parsePrivateKeyPath
) else if "%~1"=="--pw" (
    rem echo password...
    goto :parsePrivateKeyPassword
)
shift
goto loop
rem note the parse... functions do not execute the bove shift/goto since they jump back to to top of the loop bypassing this
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
:parseSrc
rem echo %~1
shift
rem echo %2
rem echo %*
rem 
if "%1"=="" (
    set /P SRC=Please enter a string to encode:
    goto :continue
)
rem FOR /F "tokens = 1 delims = \ " %%A IN ( 'ECHO.%~1' ) do SET SRC=%%A
set "SRC=%~1"
shift
goto :loop
rem 
rem 
rem 
:parsePrivateKeyPath
rem echo %~1
shift
rem echo %2
rem echo %*
rem 
if "%1"=="" (
    set /P PKP=Please enter a local path to your private key:
    goto :continue
)
if not defined PKP (
   set "PKP=%~1"
)
rem else goto dealloc
shift
goto :loop
rem 
rem 
rem 
:parsePrivateKeyPassword
rem echo %~1
shift
rem echo %2
rem echo %*
rem 
if "%1"=="" (
    set /P PKPW=Please enter your private key password 
    goto :continue
)
if not defined PKPW (
   set "PKPW=%~1"
)
rem else goto dealloc
shift
goto :loop
rem @note if neither --hex nor --base64 flag are specified, both encodings will be output
rem 
rem else if "%1"=="--S" (
rem     if defined _U ( exit /B 1 )
rem     if not defined _S ( set _S=--g )
rem )
rem 
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
            set "FLAGS=%_D% %HELP% %VERB%"
        ) else (
            set "FLAGS=%HELP% %VERB%"
        )
    ) else (
        if defined _D (
            set "FLAGS=%_D% %HELP%"
        ) else (
            set "FLAGS=%HELP%"
        )
    )
) else if defined VERB (
    if defined _D (
        set "FLAGS=%_D% %VERB%"
    ) else (
        set "FLAGS=%VERB%"
    )
) else if defined _D ( set "FLAGS=%_D%" )
rem 
rem CLI flags
if defined FLAGS (
    if defined _SSF64 (
        if defined _COMPRESS (
            if defined _CHUNK (
                set "CLI_FLAGS=%FLAGS% --ssf64 %_CHUNK% %_COMPRESS%"
            ) else (
                set "CLI_FLAGS=%FLAGS% --ssf64 %_COMPRESS%"
            )
        ) else (
            if defined _CHUNK (
                set "CLI_FLAGS=%FLAGS% --ssf64 %_CHUNK% %_COMPRESS%"
            ) else (
                set "CLI_FLAGS=%FLAGS% --ssf64 "
            )
        )
    ) else (
        if defined _COMPRESS (
            if defined _CHUNK (
                set "CLI_FLAGS=%FLAGS% %_CHUNK% %_COMPRESS%"
            ) else (
                set "CLI_FLAGS=%FLAGS% %_COMPRESS%"
            )
        ) else (
            if defined _CHUNK (
                set "CLI_FLAGS=%FLAGS% %_CHUNK%"
            ) else (
                set "CLI_FLAGS=%FLAGS%"
            )
        )
    )
) else (
    if defined _SSF64 (
        if defined _COMPRESS (
            if defined _CHUNK (
                set "CLI_FLAGS=--ssf64 %_CHUNK% %_COMPRESS%"
            ) else (
                set "CLI_FLAGS=--ssf64 %_COMPRESS%"
            )
        ) else (
            if defined _CHUNK (
                set "CLI_FLAGS=--ssf64 %_CHUNK% %_COMPRESS%"
            ) else (
                set "CLI_FLAGS=--ssf64 "
            )
        )
    ) else (
        if defined _COMPRESS (
            if defined _CHUNK (
                set "CLI_FLAGS=%_CHUNK% %_COMPRESS%"
            ) else (
                set "CLI_FLAGS=%_COMPRESS%"
            )
        ) else if defined _CHUNK (
            set "CLI_FLAGS=%_CHUNK%"
        )
    )
)
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
rem set "BUILD_DIR=%cd%\build"
rem set "SRC_DIR=%cd%\_src"
rem set SCRIPTS_DIR=%~dp0\_scripts
rem set TEST_DIR=%~dp0\_tests
rem 

if not defined OD (
    set "OD=%cd%\_output\logs\ssf32"
) 

if not defined PACKED_SIGNED_OD (
    set "PACKED_SIGNED_OD=%OD%\packedSigned"
)
rem input directory containing .txt, .json or .xml command files used for processing cli commands from markup, relative to the executing directory or absolute, relative to the executing directory or absolute
rem if not defined ID (
rem set ID=_input
set "ID=%cd%\_src"
rem 
rem set FP_LFP=%OD%\hex\files%XT%
rem set SRC_LFP=%OD%\hex\sources%XT%
rem 
set "LFP=%PACKED_SIGNED_OD%\ssfEncodeStringBase64%XT%"
rem set "SSF_ERR_LOG_PATH=%PACKED_SIGNED_OD%\ssfEncodeStringHexErrors%XT%"
rem 
rem if not defined _E (
rem ) else if not defined _PAD (
rem ) else (
rem )
rem 
rem packed
rem 
rem set "PACKED_UNSIGNED_HEX_LFP=%PACKED_SIGNED_OD%\hex%XT%"
rem set "PACKED_SIGNED_HEX_LFP=%PACKED_SIGNED_OD%\hex%XT%"
rem 
rem JSON OUTPUT PATHS
rem 
rem set "PACKED_UNSIGNED_HEX_JSON_FP=%PACKED_SIGNED_OD%\hex%JSON_XT%"
rem set "PACKED_SIGNED_HEX_JSON_FP=%PACKED_SIGNED_OD%\hex%JSON_XT%"
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
if not defined _QUIET (
    if defined FLAGS (
        echo cli arguments: %FLAGS% >> %LF%
    ) else (
        rem 
    )
)
rem if not defined SSF_CLI_PHP56 (
rem     set SSF_CLI_PHP56=%GLOBAL_PHARS_DIR%/ssf-cli-php56
rem )
rem truncate log file
rem 
rem 
rem echo %GLOBAL_PHARS_DIR%
rem 
rem 
rem exit /B %ERRORLEVEL%
rem 
rem if defined REMOVE (
rem     call :rmDirIfExists "%OD%"
rem     call :rmDirIfExists "%PACKED_SIGNED_OD%"
rem     goto dealloc
rem )
rem 
rem Make output directories if they do not exists
rem 
call :mkDirIfNotExists "%OD%"
rem 
rem exit /B %ERRORLEVEL%
rem 
call :mkDirIfNotExists "%PACKED_SIGNED_OD%"
rem call :mkDirIfNotExists "%PACKED_SIGNED_OD%"
rem 
if not defined _QUIET ( call :truncLog %LF% )
rem 
rem goto dealloc
rem 
rem get source provided by stdin
if not defined SRC (
    set /P SRC=Please enter string to encode, 
) 
if not defined PKP (
    set /P PKP=Please enter a local path to your private key, 
) 
if not defined PKPW (
    set /P PKPW=Please enter your private key password, 
) 
rem 
rem exit /B %ERRORLEVEL%
rem 
rem 
rem with source rg explicitly stated:
rem %php5% %GLOBAL_PHARS_DIR%/ssf-cli-php56/run.php --M=encode --F=directory --source=%cd% --O=%LFP% --hex
rem the current working directory which this script is executed in will be the directory used implicitly when omittted
rem 
rem packed unsigned encoding
rem 
rem %php5% %GLOBAL_PHARS_DIR%/ssf-cli-php56/run.php --M=encode --F=directory --source="%cd%\_src" --O=%PACKED_UNSIGNED_HEX_LFP% --hex
rem if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
rem 
rem %php5% %GLOBAL_PHARS_DIR%/ssf-cli-php56/run.php --M=encode --F=directory --source="%cd%\_src" --O=%PACKED_UNSIGNED_BASE64_LFP% --base64
rem if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
rem 
rem 
rem if defined _D (
rem     echo %VS_BANNER%>> %LF%
rem     echo SSF encode directory (packed unsigned hex) >> %LF%
rem     echo from: "%BUILD_DIR%" >> %LF%
rem     echo to: "%PACKED_UNSIGNED_HEX_LFP%" >> %LF%
rem )
rem 
rem clear hex log files
rem 
rem if not defined _QUIET (
    rem if defined _D (
    rem :truncLog
    rem call :truncLog %PACKED_UNSIGNED_HEX_LFP%
rem )

rem echo hex flag >> %LF%
if not defined _QUIET (
    if defined _D (
        if defined VERB (
            call :verboseLog "SSF encode string, padded signed base64" %LFP%
        ) else (
            echo SSF encode string, padded signed base64 >> %LF%
        )
        rem call :logSrcDst "%BUILD_DIR%" "%PACKED_UNSIGNED_HEX_JSON_FP%" %PACKED_UNSIGNED_HEX_LFP%
    )
)
rem 
if not exist %PKP% (
    if defined VERB (
        call :verboseLog "Local PrivateKey does not exist at path - %PKP%" %LFP%
        call :verboseLog "Terminating script with error, 3" %LFP%
    ) else (
        echo Local PrivateKey does not exist at path - %PKP% >> %LF%
        echo Terminating script with error, 3 >> %LF%
    )
    exit /b 3
)
rem packed unsigned
rem 
rem set "CMD_ARGS=--M=encode --F=str --source="%SRC%" --base64"
rem 
rem :main
if defined CLI_FLAGS (
    rem call :verboseLog "%CLI_FLAGS%" %LFP%
    %php5% %VSN_SSF_CLI_PHP56_DIR%/run.php --M=encode --F=str --source="%SRC%" --privateKey=%PKP% --password=%PKPW% --base64 --pad %CLI_FLAGS%
) else (
    %php5% %VSN_SSF_CLI_PHP56_DIR%/run.php --M=encode --F=str --source="%SRC%" --privateKey=%PKP% --password=%PKPW% --base64 --pad
)

if %ERRORLEVEL% NEQ 0 (
    echo Terminating script with error %ERRORLEVEL% >> %LF%
    echo %VS_SEP% >> %LF%
)
rem )
if %ERRORLEVEL% NEQ 0 (
    rem if defined _D (
    rem echo Terminating script with error %ERRORLEVEL% >> %LF%
    if not defined _QUIET (
        if defined VERB (
            call :verboseLog "Terminating script with error %ERRORLEVEL%" %LFP%
        ) else (
            echo Terminating script with error %ERRORLEVEL% >> %LF%
        )
        echo %VS_SEP% >> %LF%
    )
    goto dealloc
)
rem goto dealloc
rem 
rem packed signed encoding
rem 
rem exit /B %ERRORLEVEL%
rem if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
if not defined _QUIET (
    if defined _D ( echo %VS_BANNER%>> %LF% )
)
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
if not defined _QUIET (
    if defined _D (
        echo %VS_BANNER% >> %LF%
        echo script cleanup >> %LF%
        echo %VS_SEP% >> %LF%
    )
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
if defined _D ( echo removing PACKED_SIGNED_OD >> %LF% )
set PACKED_SIGNED_OD=
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
rem rem restore defult console colors
rem color
rem 
rem 
exit /B %ERRORLEVEL%
rem
:truncLog
echo %VS_BANNER% > %1 2>&1
echo @author Tyler R. Drury (vigilance.eth) >> %~1 2>&1
echo @date 10-11-2022 >> %~1 2>&1
echo @copyright Tyler R. Drury, All Rights Reserved >> %~1 2>&1
echo @created %DATE% @ %TIME% >> %~1 2>&1
echo @brief VSN (C)(TM) ssf32-packedUnsigned-base64.bat >> %~1 2>&1
echo %VS_SEP% >> %~1 2>&1
exit /b
rem 
rem 
:verboseLog
echo [%DATE%] @ %TIME% - "%~1" >> %~2 2>&1
rem echo %VS_SEP% >> %~1 2>&1
exit /b

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
rem :deallocIfErrorLevelNotZero
rem if %ERRORLEVEL% NEQ 0 (
rem     rem if defined _D (
rem     rem echo %~1 %ERRORLEVEL% >> %LFP% 2>&1
rem     if not defined _QUIET (
rem         if defined VERB (
rem             call :verboseLog "%~1 %ERRORLEVEL%" %LFP%
rem         ) else (
rem             echo %~1 %ERRORLEVEL% >> %LFP% 2>&1
rem         )
rem         echo %VS_SEP% >> %LFP% 2>&1
rem     )
rem     goto dealloc
rem )
rem 
rem :ssf32DirPackedSignedHex
rem if defined _D (
rem     echo %VS_BANNER%>> %LF%
rem     echo SSF encode directory (packed signed hex) >> %LF%
rem     echo from: "%BUILD_DIR%" >> %LF%
rem     echo to: "%PACKED_SIGNED_HEX_LFP%" >> %LF%
rem )
rem %php5% %GLOBAL_PHARS_DIR%/ssf-cli-php56/run.php --M=encode --F=directory --source="%BUILD_DIR%" --O=%PACKED_SIGNED_HEX_LFP% --hex --privateKey=%RSA_PRIVATE_KEY_FILE% --password=%UPW%
rem if %ERRORLEVEL% NEQ 0 (
rem     if defined _D (
rem         echo execution failed. >> %LF%
rem         echo %VS_SEP% >> %LF%
rem     )
rem )
rem exit /b
