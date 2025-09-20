@ECHO OFF

SET LngDir=%1

IF "%LngDir%"=="" ( 
  CALL :ShowUsageMsg
  EXIT 1
)

IF NOT EXIST "%LngDir%" (
  CALL :ShowUsageMsg
  EXIT 1
) 

CD %LngDir%   

IF NOT DEFINED BRCC SET BRCC=brcc32
%BRCC% -i..\..\source -m -foQIResStr.res QIResStr.rc
IF ERRORLEVEL 1 EXIT 1
XCOPY *.res ..\..\source
  
FOR %%N IN (5,6,7,9,10,11,12,14,15,16,17,18,19,20,21,22,23,24,25,26,27) DO (
  IF %%N LEQ 10 (
    IF EXIST ..\..\lib\D%%N XCOPY *.res ..\..\lib\D%%N\release /Q /Y
    IF EXIST ..\..\lib\C%%N XCOPY *.res ..\..\lib\C%%N\release /Q /Y        
  ) ELSE (  
    IF EXIST ..\..\lib\RS%%N (
      IF %%N GEQ 15 (
        XCOPY *.res ..\..\lib\RS%%N\win32\release /Q /Y
        IF %%N GEQ 16 XCOPY *.res ..\..\lib\RS%%N\win64\release /Q /Y          
      ) ELSE (
        XCOPY *.res ..\..\lib\RS%%N\release /Q /Y
      )
    )
  )  
)  

GOTO :EOF

:ShowUsageMsg
ECHO Please enter a language folder name as parameter. For example: LocalizeOn English