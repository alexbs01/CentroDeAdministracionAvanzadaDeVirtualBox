@ECHO OFF
CALL .\informacion\initialTitle.bat

SET PATH=%PATH%;C:\Program Files\Oracle\VirtualBox

ECHO.
ECHO  Escoge que operacion deseas realizar.
ECHO.


ECHO  e. Exportar una o varias VM a ova
ECHO  r. Registrar en Virtual Box nuevas VM
ECHO  s. Sacar una snapshot o instantanea de una o varias maquinas
ECHO  S. Salir

CHOICE /C ersS /CS /M "Pulsa la letra de la opcion deseada"

IF ERRORLEVEL 4 EXIT