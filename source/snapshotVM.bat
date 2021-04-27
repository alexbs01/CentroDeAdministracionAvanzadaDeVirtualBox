@ECHO OFF

CALL instrucciones.bat

SET fecha = date /T
DIR /B /S *.vbox >> rutasVBox.txt
ECHO. >> rutasVBox.txt
ECHO - NO BORRES ESTA ULTIMA LINEA PARA UN BUEN FUNCIONAMIENTO >> rutasVBox.txt

START rutasVBox.txt

PAUSE
 
FOR /F %%i IN (rutasVBox.txt) DO (
	START /WAIT C:\"Program Files"\Oracle\VirtualBox\vboxmanage snapshot %%i take "Captura hecha a %date% %time%" && ECHO Captura de la maquina %%i tomada
)

DEL rutasVBox.txt

REM ECHO.
REM ECHO ES OBLIGATORIO QUE EN TODA LA RUTA DE LA MAQUINA VIRTUAL NO HAYA ESPACIOS
REM ECHO.
REM ECHO *****************
REM ECHO * Instrucciones *
REM ECHO *****************
REM ECHO.
REM ECHO 1. Cuando se abra el archivo de texto borra las rutas de las maquinas que no quieras tomar una captura
REM ECHO 2. Cuando lo en el .txt solo haya la maquinas deseadas GUARDA el archivo y cierralo
REM ECHO 3. Despues solo espera
REM ECHO.
REM PAUSE