@ECHO OFF

CALL ..\informacion\instructions.bat
:: Muestra las instrucciones

CALL vmSearcher.bat
:: Buscador de VM

SET fecha = date /T

 
FOR /F %%i IN (routesVBox.txt) DO (
	START /WAIT vboxmanage snapshot %%i take "Captura hecha a %date% %time%" && ECHO Captura de la maquina %%i tomada
)
:: Hace las instantaneas poniendo como nombre el texto de entre comillas

DEL routesVBox.txt

