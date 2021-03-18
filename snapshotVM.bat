@ECHO OFF
ECHO.
ECHO ES OBLIGATORIO QUE EN TODA LA RUTA DE LA MAQUINA VIRTUAL NO HAYA ESPACIOS
ECHO.
ECHO *****************
ECHO * Instrucciones *
ECHO *****************
ECHO.
ECHO 1. Cuando se abra el archivo de texto borra las rutas de las maquinas que no quieras tomar una captura
ECHO 2. Cuando lo en el .txt solo haya la maquinas deseadas GUARDA el archivo y cierralo
ECHO 3. Despues solo espera
ECHO.
PAUSE

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