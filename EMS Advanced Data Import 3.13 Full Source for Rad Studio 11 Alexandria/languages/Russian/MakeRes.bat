@ECHO OFF
FOR %%* IN (.) DO SET CurrDir=%%~n*
CD ..
CALL LocalizeOn.bat %CurrDir%