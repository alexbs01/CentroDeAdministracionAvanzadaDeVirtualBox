@ECHO OFF

CALL instrucciones.bat

DIR /B /S *.vbox >> direcciones.txt

START direcciones.txt

PAUSE
 
FOR /F %%i IN (direcciones.txt) DO (
	START /b C:\"Program Files"\Oracle\VirtualBox\vboxmanage registervm %%i
	IF %ERRORLEVEL% == 0 ECHO Maquina %%i anhadida
)

DEL direcciones.txt

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