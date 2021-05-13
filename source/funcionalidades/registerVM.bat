@ECHO OFF

CALL ..\informacion\instructions.bat
:: Muestra las instrucciones

CALL vmSearcher.bat
:: Llama al buscador de VM

FOR /F %%i IN (routesVBox.txt) DO (
	START vboxmanage registervm %%i
	IF %ERRORLEVEL% == 0 ECHO Maquina %%i anhadida
)
:: Registra las maquinas que el buscador encontro

DEL routesVBox.txt

