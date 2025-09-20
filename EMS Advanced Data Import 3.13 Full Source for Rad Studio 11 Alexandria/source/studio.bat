@echo off

ECHO.
ECHO ===
ECHO = BUILD D%1
ECHO ===

:: params
SET BAT_DIR=%~dp0
SET NUM=%1
SET STUDIO_HOME=%~f2
SET WORK_DIR=%~f3
SET OUTPUT_ROOT=%~f4
SET BPL_DIR=%~f5
SET BPL_LOG=%~f6

:: remove trailing backslash
SET BAT_DIR=%BAT_DIR:~0,-1%

:: check BPL_DIR param
SET FULL_MODE=0
IF NOT "%BPL_DIR%"=="" (
  IF EXIST "%BPL_DIR%" (
    SET FULL_MODE=1
  )
)

:: output build command line 
IF %FULL_MODE% EQU 1 (
  ECHO. & ECHO Build command line:
  ECHO %0 %1 %2 %3 %4 %5
)

:: since Delphi2009 (version 12) property "Config"
IF %NUM% GEQ 12 (
  SET PROP_CONFIG=Config
) ELSE (
  SET PROP_CONFIG=Configuration
)

:: since DelphiXE (version 15) platform "Win32"
IF %NUM% GEQ 15 (
  SET PLATFORM_VAL=Win32
  SET PLATFORM_DIR=win32
) ELSE (
  SET PLATFORM_VAL=AnyCPU
  :: empty platform directory
  SET PLATFORM_DIR=
)

CALL "%STUDIO_HOME%\bin\rsvars.bat"
:: replace Framework64 substring with Framework
SET PATH=%PATH:Framework64=Framework%
:: replace \Windows\Microsoft.NET\Framework\v4.5 substring with \Windows\Microsoft.NET\Framework\v4.0.30319
SET PATH=%PATH:\Windows\Microsoft.NET\Framework\v4.5=\Windows\Microsoft.NET\Framework\v4.0.30319%

CD "%WORK_DIR%"
IF NOT EXIST dcu MKDIR dcu

SET OUT_RELEASE=%OUTPUT_ROOT%\%PLATFORM_DIR%\release
SET OUT_HPP=%OUTPUT_ROOT%\%PLATFORM_DIR%\hpp
IF EXIST "%OUT_RELEASE%" RMDIR /S /Q "%OUT_RELEASE%"
IF EXIST "%OUT_HPP%" RMDIR /S /Q "%OUT_HPP%"
MKDIR "%OUT_RELEASE%"
MKDIR "%OUT_HPP%"
ECHO. & ECHO ########## build Release Win32 run-time package ##########
MSBUILD.EXE /t:Build /p:%PROP_CONFIG%=Release;Platform=%PLATFORM_VAL%;DCC_BplOutput="%OUT_RELEASE%";DCC_DcpOutput="%OUT_RELEASE%";DCC_DcuOutput="%OUT_RELEASE%";DCC_BpiOutput="%OUT_RELEASE%";DCC_HppOutput="%OUT_HPP%";DCC_ObjOutput="%OUT_RELEASE%";DCC_CBuilderOutput=All;DCC_Quiet=True /verbosity:n QImport3RT.dproj
IF ERRORLEVEL 1 GOTO RTError

:: define expected_hpp suffix
SET HPP_SUFF=
IF %NUM% LSS 16 (
  IF %NUM% EQU 11 (
    SET HPP_SUFF=_C11
  ) ELSE (
    SET HPP_SUFF=_C12
  )
)

IF EXIST "%OUT_HPP%\QImport3RT.hpp" DEL "%OUT_HPP%\QImport3RT.hpp"
:: check compiled hpp files for trial build
IF %FULL_MODE% EQU 0 (
  DIR /B "%OUT_HPP%\*.hpp" > "%OUT_HPP%\compiled_hpp.txt"
  FC /A "%BAT_DIR%\expected_hpp%HPP_SUFF%.txt" "%OUT_HPP%\compiled_hpp.txt"
  IF ERRORLEVEL 1 GOTO RTError
)

IF %FULL_MODE% EQU 1 (
  COPY /Y "%OUT_RELEASE%\QImport3RT*.bpl" "%BPL_DIR%"
  FOR %%I IN (QIEULA.res QIResStr.res QImport3InfoPanel.res QImport3EZDSLCTS.R32) DO COPY /Y "%WORK_DIR%\..\..\source\%%I" "%OUT_RELEASE%"
  FOR %%I IN (fuQImport3License.dfm fuQImport3Loading.dfm fuQImport3ProgressDlg.dfm fuQImport3ReplacementEdit.dfm fuQImport3XLSRangeEdit.dfm QImport3Wizard.dfm) DO COPY /Y "%WORK_DIR%\..\..\source\%%I" "%OUT_RELEASE%"
)

ECHO. & ECHO ########## build Release Win32 design-time package ##########
MSBUILD.EXE /t:Build /p:%PROP_CONFIG%=Release;Platform=%PLATFORM_VAL%;DCC_BplOutput="%OUT_RELEASE%";DCC_DcpOutput="%OUT_RELEASE%";DCC_DcuOutput=dcu;DCC_BpiOutput="%OUT_RELEASE%";DCC_HppOutput=dcu;DCC_ObjOutput=dcu;DCC_CBuilderOutput=All;DCC_Quiet=True /verbosity:n QImport3DT.dproj
IF ERRORLEVEL 1 GOTO DTError

SET OUT_DEBUG=%OUTPUT_ROOT%\%PLATFORM_DIR%\debug
IF %FULL_MODE% EQU 1 (
  IF EXIST "%OUT_DEBUG%" RMDIR /S /Q "%OUT_DEBUG%"
  MKDIR "%OUT_DEBUG%"
  DEL /Q dcu\*.*
  ECHO. & ECHO ########## build Debug Win32 run-time package ##########
  MSBUILD.EXE /t:Build /p:%PROP_CONFIG%=Debug;Platform=%PLATFORM_VAL%;DCC_BplOutput=dcu;DCC_DcpOutput="%OUT_DEBUG%";DCC_DcuOutput="%OUT_DEBUG%";DCC_BpiOutput=dcu;DCC_HppOutput=dcu;DCC_ObjOutput="%OUT_DEBUG%";DCC_CBuilderOutput=All;DCC_Quiet=True /verbosity:n QImport3RT.dproj
  IF ERRORLEVEL 1 GOTO RTError
)

:: since DelphiXE2 (version 16) build Win64; define OUT_RELEASE outside IF
SET OUT_RELEASE=%OUTPUT_ROOT%\win64\release
SET OUT_HPP=%OUTPUT_ROOT%\win64\hpp
SET OUT_DEBUG=%OUTPUT_ROOT%\win64\debug
IF %NUM% GEQ 16 (
  IF EXIST "%STUDIO_HOME%\bin\dcc64.exe" (
    IF EXIST "%OUT_RELEASE%" RMDIR /S /Q "%OUT_RELEASE%"
    IF EXIST "%OUT_HPP%" RMDIR /S /Q "%OUT_HPP%"
    MKDIR "%OUT_RELEASE%"
    MKDIR "%OUT_HPP%"
    ECHO. & ECHO ########## build Release Win64 run-time package ##########
    MSBUILD.EXE /t:Build /p:%PROP_CONFIG%=Release;Platform=Win64;DCC_BplOutput="%OUT_RELEASE%";DCC_DcpOutput="%OUT_RELEASE%";DCC_DcuOutput="%OUT_RELEASE%";DCC_BpiOutput="%OUT_RELEASE%";DCC_HppOutput="%OUT_HPP%";DCC_ObjOutput="%OUT_RELEASE%";DCC_CBuilderOutput=All;DCC_Quiet=True /verbosity:n QImport3RT.dproj
    IF ERRORLEVEL 1 GOTO RTError

    IF %NUM% GEQ 17 (
      IF EXIST "%OUT_HPP%\QImport3RT.hpp" DEL "%OUT_HPP%\QImport3RT.hpp"
      :: check compiled hpp files for trial build
      IF %FULL_MODE% EQU 0 (
        DIR /B "%OUT_HPP%\*.hpp" > "%OUT_HPP%\compiled_hpp.txt"
        FC /A "%BAT_DIR%\expected_hpp.txt" "%OUT_HPP%\compiled_hpp.txt"
        IF ERRORLEVEL 1 GOTO RTError
      )
    )

    IF %FULL_MODE% EQU 1 (
      IF NOT EXIST "%BPL_DIR%\win64" MKDIR "%BPL_DIR%\win64"
      COPY /Y "%OUT_RELEASE%\QImport3RT*.bpl" "%BPL_DIR%\win64"
      FOR %%I IN (QIEULA.res QIResStr.res QImport3InfoPanel.res QImport3EZDSLCTS.R32) DO COPY /Y "%WORK_DIR%\..\..\source\%%I" "%OUT_RELEASE%"
      FOR %%I IN (fuQImport3License.dfm fuQImport3Loading.dfm fuQImport3ProgressDlg.dfm fuQImport3ReplacementEdit.dfm fuQImport3XLSRangeEdit.dfm QImport3Wizard.dfm) DO COPY /Y "%WORK_DIR%\..\..\source\%%I" "%OUT_RELEASE%"
    )

    IF %FULL_MODE% EQU 1 (
      IF EXIST "%OUT_DEBUG%" RMDIR /S /Q "%OUT_DEBUG%"
      MKDIR "%OUT_DEBUG%"
      DEL /Q dcu\*.*
      ECHO. & ECHO ########## build Debug Win64 run-time package ##########
      MSBUILD.EXE /t:Build /p:%PROP_CONFIG%=Debug;Platform=Win64;DCC_BplOutput=dcu;DCC_DcpOutput="%OUT_DEBUG%";DCC_DcuOutput="%OUT_DEBUG%";DCC_BpiOutput=dcu;DCC_HppOutput=dcu;DCC_ObjOutput="%OUT_DEBUG%";DCC_CBuilderOutput=All;DCC_Quiet=True /verbosity:n QImport3RT.dproj
      IF ERRORLEVEL 1 GOTO RTError
    )
  ) ELSE (
    ECHO "%STUDIO_HOME%\bin\dcc64.exe" not found.
  )
)

IF %NUM% GEQ 16 (
  DEL *.res
)
IF EXIST dcu RMDIR /S /Q dcu

GOTO :EOF

:RTError
IF NOT "%BPL_LOG%"=="" ECHO %WORK_DIR%\QImport3RT.dproj >>"%BPL_LOG%"
EXIT 10%NUM%

:DTError
IF NOT "%BPL_LOG%"=="" ECHO %WORK_DIR%\QImport3DT.dproj >>"%BPL_LOG%"
EXIT 11%NUM%