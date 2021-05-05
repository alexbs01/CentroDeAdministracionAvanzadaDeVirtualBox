@ECHO OFF

CALL ..\informacion\instructions.bat

CALL vmSearcher.bat
 
FOR /F %%i IN (routesVBox.txt) DO (
	START vboxmanage registervm %%i
	IF %ERRORLEVEL% == 0 ECHO Maquina %%i anhadida
)

DEL routesVBox.txt

REM ECHO.
REM ECHO **************
REM ECHO * REQUISITOS *
REM ECHO **************
REM ECHO.
REM ECHO ES OBLIGATORIO QUE EN TODA LA RUTA DE LA MAQUINA VIRTUAL NO HAYA ESPACIOS
REM ECHO.
REM ECHO *****************
REM ECHO * Instrucciones *
REM ECHO *****************
REM ECHO.
REM ECHO 1. Cuando se abra el archivo de texto borra las rutas de las maquinas que no quieres anhadir a VirtualBox
REM ECHO 2. Cuando lo en el .txt solo haya la maquinas deseadas GUARDA el archivo y cierralo
REM ECHO 3. Despues solo espera
REM ECHO.
REM PAUSE