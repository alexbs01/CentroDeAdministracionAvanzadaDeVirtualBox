@ECHO OFF
ECHO.
ECHO **************
ECHO * REQUISITOS *
ECHO **************
ECHO.
ECHO ES OBLIGATORIO QUE EN TODA LA RUTA DE LA MAQUINA VIRTUAL NO HAYA ESPACIOS
ECHO.
ECHO *****************
ECHO * Instrucciones *
ECHO *****************
ECHO.
ECHO 1. Cuando se abra el archivo de texto borra las rutas de las maquinas que no quieres anhadir a VirtualBox
ECHO 2. Cuando lo en el .txt solo haya la maquinas deseadas GUARDA el archivo y cierralo
ECHO 3. Despues solo espera
ECHO.
PAUSE

DIR /B /S *.vbox >> direcciones.txt

START direcciones.txt

PAUSE
 
FOR /F %%i IN (direcciones.txt) DO (
	START /b C:\"Program Files"\Oracle\VirtualBox\vboxmanage registervm %%i
	IF %ERRORLEVEL% == 0 ECHO Maquina %%i anhadida
)

DEL direcciones.txt