@ECHO OFF

CALL ..\informacion\instructions.bat

CALL vmSearcher.bat
 
FOR /F %%i IN (routesVBox.txt) DO (
	START /WAIT vboxmanage export %%i --output %%i.ova && ECHO Maquina %%i exportada
)

DEL routesVBox.txt

DIR /B /S *.vbox.ova >> rutasOva.txt

MKDIR ovasDeMaquinas
FOR /F %%i IN (rutasOva.txt) DO (
	MOVE /Y %%i ovasDeMaquinas && ECHO Maquina %%i movida
)

DEL rutasOva.txt

..\main.bat

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