@ECHO OFF

CALL ..\informacion\instructions.bat
:: Muestra las instrucciones

CALL vmSearcher.bat
:: Llama al buscador de maquinas para abrir el txt

FOR /F %%i IN (routesVBox.txt) DO (
	START /WAIT vboxmanage export %%i --output %%i.ova && ECHO Maquina %%i exportada
)
:: Exporta las VM una por una en ovas independientes

DEL routesVBox.txt

DIR /B /S *.vbox.ova >> rutasOva.txt

MKDIR ovasDeMaquinas
FOR /F %%i IN (rutasOva.txt) DO (
	MOVE /Y %%i ovasDeMaquinas && ECHO Maquina %%i movida
)
:: Mueve todas las ova a una carpeta

DEL rutasOva.txt
