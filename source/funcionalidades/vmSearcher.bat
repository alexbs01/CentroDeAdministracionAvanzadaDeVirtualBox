@ECHO OFF
:: Este archivo busca todos los archivos .vbox a partir de el,
:: guarda las rutas en un txt y lo muestra

DIR /B /S *.vbox >> routesVBox.txt
ECHO. >> routesVBox.txt
ECHO NO BORRES ESTA ULTIMA LINEA PARA UN BUEN FUNCIONAMIENTO >> routesVBox.txt

START routesVBox.txt

PAUSE