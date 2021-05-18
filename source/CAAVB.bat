@ECHO OFF&call:primerInicio&goto:EOF
:: El programa comienza en la etiqueta "primerInicio"

:initialTitle
:: Las etiquetas del GOTO se pueden usar para indicar funciones, esta se usara cuando 
:: se escoja una opcion a realizar
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
:: "GOTO:EOF" indica el fin de la funcion

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

:queHacerModifyVM
ECHO.
ECHO n. Cambiar configuracion en otras maquinas
ECHO m. Modificar las mismas maquinas
ECHO S. Salir al menu principales

CHOICE /C Smn /CS /M "Escoge la opcion que desees: "

IF ERRORLEVEL 3 (
	CLS
	GOTO queHacerModifyVM_nuevasVM
)

IF ERRORLEVEL 2 (
	CLS
	DEL listVM.txt
	GOTO queHacerModifyVM_sinNuevasVM
)

IF ERRORLEVEL 1 (
	CLS
	IF EXIST listVM.txt DEL listVM.txt
	GOTO inicio
)

GOTO:EOF

:exportOvaVM
	CALL:instructions
	:: Muestra las instrucciones

	CALL:vmSearcher
	:: Llama al buscador de maquinas para abrir el txt
MKDIR ovasDeMaquinas
	FOR /F %%i IN (routesVBox.txt) DO (
		START /B /WAIT vboxmanage export %%i --output %%i.ova && ECHO Maquina %%i exportada
	)
	:: Exporta las VM una por una en ovas independientes


	DIR /B /S *.vbox.ova >> routesOva.txt

	REM MKDIR ovasDeMaquinas
	REM FOR /F %%i IN (routesOva.txt) DO (
		REM MOVE /Y %%i ovasDeMaquinas && ECHO Maquina %%i movida
	REM )
	:: Mueve todas las ova a una carpeta

	DEL routesOva.txt
	DEL routesVBox.txt
GOTO:EOF

:registerVM
	CALL:instructions

	CALL:vmSearcher

	FOR /F %%i IN (routesVBox.txt) DO (
		START /B vboxmanage registervm %%i
		IF %ERRORLEVEL% == 0 ECHO Maquina %%i anhadida
	)
	:: Registra las maquinas que el buscador encontro

	DEL routesVBox.txt
GOTO:EOF

:snapshotVM
	CALL:instructions

	CALL:vmSearcher

	SETLOCAL enableextensions enabledelayedexpansion
	:: Permite la reasignacion de variables
	
	SET fecha = date /T
	SET /P snapshotName="Nombre de la instantanea [Por defecto fecho y hora]: "
	
	IF DEFINED snapshotName (
		FOR /F %%i IN (routesVBox.txt) DO (
			START /B /WAIT vboxmanage snapshot %%i take "!snapshotName!" && ECHO Captura de la maquina %%i tomada
		)
	) ELSE (
		FOR /F %%i IN (routesVBox.txt) DO (
			START /B /WAIT vboxmanage snapshot %%i take "Captura hecha a %date% %time%" && ECHO Captura de la maquina %%i tomada
		)
	)
	:: Hace las instantaneas poniendo como nombre el texto de entre comillas
	ENDLOCAL
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

:modifyVM
	SETLOCAL enableextensions enabledelayedexpansion
	CALL:instructions
	
	:queHacerModifyVM_nuevasVM
	IF EXIST listVM.txt DEL listVM.txt
	CALL VBoxManage list vms >> listVM.txt
	START listVM.txt
	
	:queHacerModifyVM_sinNuevasVM
	ECHO.
	ECHO Selecciona la opcion de la caracteristica que quieras cambiar
	ECHO.
	ECHO r. Modificar el numero de MB de RAM
	ECHO v. Modificar el numero de MB de memoria grafica o VRAM
	ECHO c. Cambiar el numero de nucleos virtuales a los que tendra acceso cada maquina
	ECHO R. Redimensionar la capacidad de los discos duros para aumentarlos
	ECHO S. Salir al menu de opciones principales
	
	CHOICE /C SRcvr /CS /M "Pulsa la letra de la opcion deseada"
	
	IF ERRORLEVEL 5 (
	:: Cambiar la cantidad de RAM
		ECHO.
		ECHO Pon el numero de MB de RAM de las VM
		SET /P numberRAM="Ten en cuenta la RAM de tu ordenador por si abres varias VM a la vez: "
		FOR /F "tokens=1,2" %%i IN (listVM.txt) DO (
			START /B /WAIT VBoxManage modifyvm %%j --memory !numberRAM!
		)
		CALL:queHacerModifyVM
	)
	
	IF ERRORLEVEL 4 (
	:: Modificar la memoria grafica
		ECHO.
		ECHO Pon el numero de megas de memoria grafica
		SET /P numberVRAM="Ten en cuenta la memoria grafica de tu ordenador y que el maximo 256 MB: "
		FOR /F "tokens=1,2 delims= " %%i IN (listVM.txt) DO (
			START /B /WAIT VBoxManage modifyvm %%j --vram !numberVRAM!
		)
		CALL:queHacerModifyVM
	)
	
	IF ERRORLEVEL 3 (
	:: Cambiar el numero de nucleos virtuales
		ECHO.
		ECHO Pon el numero de nucleos virtuales de las maquinas
		SET /P numberCPU="Ten en cuenta el numero de nucleos de tu ordenador: "
		FOR /F "tokens=1,2" %%i IN (listVM.txt) DO (
			START /B VBoxManage modifyvm %%j --cpus !numberCPU!
		)
		CALL:queHacerModifyVM
	)
	
	IF ERRORLEVEL 2 (
	:: Redimensionar la capacidad
		ECHO.
		ECHO Escoge los discos sobre los que quieres redimensionar la capacidad
		PAUSE
		DIR /B /S *.vdi | FINDSTR /V "{.*}" >> listVDI.txt
		::DIR /B /S *.vmdk | FINDSTR /V "{.*}" >> listVDI.txt
		:: Busca todos los discos con extensión .vdi que no pertenezaca a snapshots y las guarda en el txt
		
		START listVDI.txt
		PAUSE
		ECHO Una vez que aumentes la capacidad, no podras reducirla
		ECHO.
		SET /P megasModifymedium="Pon el numero de megas que tendran los Discos Duros, mejor pasarse que quedarse corto: "
		FOR /F %%i IN (listVDI.txt) DO (
			START /B /WAIT VBoxManage modifymedium disk "%%i" --resize !megasModifymedium!
		)
		:: Redimensiona los discos seleccionados
		DEL listVDI.txt
		GOTO queHacerModifyVM_nuevasVM
	)
	
	IF ERRORLEVEL 1 (
		ENDLOCAL
		CLS
		IF EXIST listVM.txt DEL listVM.txt
		GOTO inicio
	)
	DEL listVM.txt
	ENDLOCAL
	GOTO inicio
	
GOTO:EOF

:escogerOtraVez
	PAUSE
	CLS
	GOTO inicio
GOTO:EOF


:primerInicio
:: Con el primer inicio del programa mostrara el titulo inicial y añadira al path la ruta de VirtualBox
:: y asi poder usar sus comandos.
	CALL:initialTitle
	SET PATH=%PATH%;C:\Program Files\Oracle\VirtualBox

:inicio
:: Una vez se escoge una opcion limpiara la pantalla y mostrara a partir de aqui las siguientes veces
	ECHO.
	ECHO  Escoge que operacion deseas realizar.
	ECHO.
	
	ECHO  m. Modificar la configuracion de maquinas virtuales
	ECHO  l. Listar las maquinas registradas
	ECHO  d. Desregistrar maquinas con estado inaccesible
	ECHO  D. Desregistrar maquinas que se seleccionen
	ECHO  e. Exportar una o varias VM a ova
	ECHO  r. Registrar en VirtualBox nuevas VM
	ECHO  s. Sacar una snapshot o instantanea de una o varias maquinas
	ECHO  S. Salir

	CHOICE /C SsreDdlm /CS /M "Pulsa la letra de la opcion deseada"
	:: Se escoge la opcion deseada, que redirigira al errorlevel correspondiente

	IF ERRORLEVEL 8 (
	:: Modificar las caracteristicas de VM
		CLS
		CALL:modifyVM
		CALL:escogerOtraVez
	)
	
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