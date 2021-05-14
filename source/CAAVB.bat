@ECHO OFF&call:primerInicio&goto:EOF
:: El programa comienza en la etiqueta "primerInicio"

:initialTitle
	CLS
	ECHO.

	ECHO                                  ****************************************************
	ECHO                                  * Centro de Administracion Avanzada de Virtual Box *
	ECHO                                  ****************************************************
	ECHO.

	ECHO    Es un conjunto de archivos escritos en Batch con la finalidad de realizar tareas repetitivas, tediosas, largas o que solo se pueden hacer de forma masiva mediante scripts.
	ECHO.

	ECHO    Estas tareas se realizan haciando uso de los comandos que el programa Virtual Box pone a nuestra disposicion para manejar y hacer todo tipo de operaciones con las maquinas virtuales de este mismo software.
	ECHO.
GOTO:EOF

:instructions
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
	ECHO 1. Cuando se abra el archivo de texto borra las rutas de las maquinas en las que no quieras aplicar la acción
	ECHO 2. Cuando lo en el .txt solo haya la maquinas deseadas GUARDA el archivo y cierralo
	ECHO 3. Despues solo espera
	ECHO.
	PAUSE
GOTO:EOF

:vmSearcher
	:: Este archivo busca todos los archivos .vbox a partir de el,
	:: guarda las rutas en un txt y lo muestra

	DIR /B /S *.vbox >> routesVBox.txt
	ECHO. >> routesVBox.txt
	ECHO NO BORRES ESTA ULTIMA LINEA PARA UN BUEN FUNCIONAMIENTO >> routesVBox.txt

	START routesVBox.txt

	PAUSE
GOTO:EOF

:exportOva
	CALL:instructions
	:: Muestra las instrucciones

	CALL:vmSearcher
	:: Llama al buscador de maquinas para abrir el txt

	FOR /F %%i IN (routesVBox.txt) DO (
		START /WAIT vboxmanage export %%i --output %%i.ova && ECHO Maquina %%i exportada
	)
	:: Exporta las VM una por una en ovas independientes


	DIR /B /S *.vbox.ova >> routesOva.txt

	MKDIR ovasDeMaquinas
	FOR /F %%i IN (routesOva.txt) DO (
		MOVE /Y %%i ovasDeMaquinas && ECHO Maquina %%i movida
	)
	:: Mueve todas las ova a una carpeta

	DEL routesOva.txt
	DEL routesVBox.txt
GOTO:EOF

:registerVM
	CALL:instructions
	:: Muestra las instrucciones

	CALL:vmSearcher
	:: Llama al buscador de VM

	FOR /F %%i IN (routesVBox.txt) DO (
		START vboxmanage registervm %%i
		IF %ERRORLEVEL% == 0 ECHO Maquina %%i anhadida
	)
	:: Registra las maquinas que el buscador encontro

	DEL routesVBox.txt
GOTO:EOF

:registerVM
	CALL:instructions
	:: Muestra las instrucciones

	CALL:vmSearcher
	:: Buscador de VM

	SET fecha = date /T

	 
	FOR /F %%i IN (routesVBox.txt) DO (
		START /WAIT vboxmanage snapshot %%i take "Captura hecha a %date% %time%" && ECHO Captura de la maquina %%i tomada
	)
	:: Hace las instantaneas poniendo como nombre el texto de entre comillas

	DEL routesVBox.txt
GOTO:EOF

:unregisterInaccessibleVM
	CHOICE /M "Estas seguro que quieres desregistrar las VM inaccesibles?"
	:: Da la opcion a escoger si realmente quieres desregistrarlas o no

	IF ERRORLEVEL 2 GOTO fin

	IF ERRORLEVEL 1 (

		START /B /WAIT VBoxManage list vms >> listVM.txt
		:: Hace la lista de maquinas registradas y la guarda en un txt

		FINDSTR "\<\<.*\>\>" listVM.txt >> onlyVMUnregister.txt
		:: Busca las lineas que contengan un string que inicie con "<" y finalice con ">", 
		:: esas lineas las guarda en otro txt de solo maquinas inaccesibles 
		:: Ej lista: "<inaccesible>" {000-000000-0000000-0000000-00000-000}

		FOR /F "tokens=1,2" %%i IN (onlyVMUnregister.txt) DO (
			START /B VBoxManage unregistervm %%j
		)
		:: Desregistra las VM del archivo usando su identificador, el numero de las llaves
		
		ECHO.
		ECHO ***************************************************
		ECHO * Maquinas virtuales inaccesibles desregistradas. *
		ECHO ***************************************************
		
		DEL listVM.txt
		DEL onlyVMUnregister.txt
	)
	:fin
GOTO:EOF

:unregisterVM
	CALL VBoxManage list vms >> listVM.txt
	START listVM.txt
	:: Lista las maquinas registradas y las guarda en un txt

	PAUSE

	FOR /F "tokens=1,2" %%i IN (listVM.txt) DO (
		START /B /WAIT VBoxManage unregistervm %%j
	)
	:: Desregistra las maquinas que se dejaron en el txt

	ECHO.
	ECHO ***************************************************
	ECHO * Maquinas virtuales inaccesibles desregistradas. *
	ECHO ***************************************************

	DEL listVM.txt
GOTO:EOF

:escogerOtraVez
:: Las etiquetas del GOTO se pueden usar para indicar funciones, esta se usara cuando 
:: se escoja una opcion a realizar
	PAUSE
	CLS
	GOTO inicio
GOTO:EOF
:: "GOTO:EOF" indica el fin de la funcion

:primerInicio
:: Con el primer inicio del programa mostrara el titulo inicial y añadira al path la ruta de VirtualBox
	CALL:initialTitle
	SET PATH=%PATH%;C:\Program Files\Oracle\VirtualBox

:inicio
:: Una vez se escoge una opcion limpiara la pantalla y mostrara a partir de aqui las siguientes veces
	ECHO.
	ECHO  Escoge que operacion deseas realizar.
	ECHO.

	ECHO  l. Listar las maquinas registradas
	ECHO  d. Desregistrar maquinas con estado inaccesible
	ECHO  D. Desregistrar maquinas que se seleccionen
	ECHO  e. Exportar una o varias VM a ova
	ECHO  r. Registrar en VirtualBox nuevas VM
	ECHO  s. Sacar una snapshot o instantanea de una o varias maquinas
	ECHO  S. Salir

	CHOICE /C SsreDdl /CS /M "Pulsa la letra de la opcion deseada"
	:: Se escoge la opcion deseada, que redirigira al errorlevel correspondiente

	IF ERRORLEVEL 7 (
	:: Listar VM
		ECHO.
		START /B /WAIT vboxmanage list vms
		CALL:escogerOtraVez
	)	
		
	IF ERRORLEVEL 6 (
	:: Desregistrar VM en estado inaccesible
		CLS
		CALL:unregisterInaccessibleVM
		CALL:escogerOtraVez
	)

	IF ERRORLEVEL 5 (
	:: Desregistrar VM que se deseen
		CLS
		CALL:unregisterVM
		CALL:escogerOtraVez
	)

	IF ERRORLEVEL 4 (
	:: Exportar a ova la VM que se seleccionen
		CLS
		CALL:exportOvaVM
		CALL:escogerOtraVez
	)

	IF ERRORLEVEL 3 (
	:: Registrar VM
		CLS
		CALL:registerVM
		CALL:escogerOtraVez
	)

	IF ERRORLEVEL 2 (
	:: Hacer una snapshot de las VM
		CLS
		CALL:snapshotVM
		CALL:escogerOtraVez
	)

	IF ERRORLEVEL 1 EXIT

	GOTO inicio