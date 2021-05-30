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
	ECHO Creado por Alejandro Becerra
	ECHO Repositorio a GitHub del proyecto: https://github.com/alexbs01/CentroDeAdministracionAvanzadaDeVirtualBox
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
	ECHO 1. Cuando se abra el archivo de texto borra las rutas de las maquinas en las que no quieras aplicar la accion
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
	ECHO - NO BORRES ESTA ULTIMA LINEA PARA UN BUEN FUNCIONAMIENTO >> routesVBox.txt

	START routesVBox.txt

	PAUSE
GOTO:EOF

:queHacerModifyVM
:: Una vez finalice el proceso de cambios de configuracion en las VM (:modifyVM) el programa vendra aqui
:: a decidir si escoger nuevas VM, seguir modificando las mismas o salir al menu principal.
	CLS
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
	SET fecha=%date%
	START /B /WAIT VBoxManage list vms >> listVM.txt
	START listVM.txt
	ECHO. >> listVM.txt
	ECHO - NO BORRES ESTA ULTIMA LINEA PARA UN BUEN FUNCIONAMIENTO >> listVM.txt
	PAUSE
	
	CLS
	ECHO.
	ECHO ***************************
	ECHO * Exportar maquinas a OVA *
	ECHO ***************************
	ECHO.
	
	IF NOT EXIST ovasDeMaquinas_%date:/=_% MKDIR ovasDeMaquinas_%date:/=_%
	FOR /F "tokens=1,2" %%i IN (listVM.txt) DO (
		IF "%%i" == "-" GOTO moverOvas
		START /B /WAIT vboxmanage export %%j --output %%i_%fecha:/=_%.ova && ECHO Maquina %%i exportada
		ECHO.
	)
	:moverOvas
	:: Exporta las VM una por una en ovas independientes
	ECHO.
	ECHO MAQUINAS EXPORTADAS, A CONTINUACION SE MOVERAN A UNA CARPETA
	ECHO.
	DIR /B /S *_%fecha:/=_%.ova >> routesOva.txt

	FOR /F %%i IN (routesOva.txt) DO (
		MOVE /Y %%i ovasDeMaquinas_%date:/=_% && ECHO Maquina %%i movida
		ECHO.
	)
	:: Mueve todas las ova a una carpeta

	DEL routesOva.txt
	DEL listVM.txt
GOTO:EOF

:registerVM
	CALL:instructions

	CALL:vmSearcher
	CLS
	ECHO.
	ECHO ********************************
	ECHO * Registrar maquinas virtuales *
	ECHO ********************************
	ECHO.

	FOR /F %%i IN (routesVBox.txt) DO (
		IF "%%i" == "-" GOTO finRegistro
		START /B vboxmanage registervm %%i
		IF %ERRORLEVEL% == 0 ECHO Maquina %%i anhadida
	)
	:: Registra las maquinas que el buscador encontro
	:finRegistro
	DEL routesVBox.txt
GOTO:EOF

:snapshotVM
	CALL:instructions

	CALL:vmSearcher
	CLS
	ECHO.
	ECHO ***********************************
	ECHO * Snapshots de maquinas virtuales *
	ECHO ***********************************
	ECHO.

	SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
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
	CLS
	ECHO.
	ECHO *****************************************
	ECHO * Desregistrar VM en estado inaccesible *
	ECHO *****************************************
	ECHO.
	
	CHOICE /M "Estas seguro que quieres desregistrar las VM inaccesibles?"
	:: La opcion de si se quieren desregistrar o no

	IF ERRORLEVEL 2 GOTO fin

	IF ERRORLEVEL 1 (

	START /B /WAIT VBoxManage list vms >> listVM.txt

	FINDSTR "\<\<.*\>\>" listVM.txt >> onlyVMUnregister.txt
	:: En el archivo que se crea busca todas aquellas maquinas que empiezan por < y terminan por >
	:: esto ya que las maquinas en estado inaccesible tienen estos caracteres
	FOR /F "tokens=1,2" %%i IN (onlyVMUnregister.txt) DO (
		START /B VBoxManage unregistervm %%j
	)
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
	CLS
	ECHO.
	ECHO *************************
	ECHO * Desregistrar maquinas *
	ECHO *************************
	ECHO.
	CALL VBoxManage list vms >> listVM.txt
	START listVM.txt
	:: Lista las maquinas registradas y las guarda en un txt

	PAUSE

	FOR /F "tokens=1,2" %%i IN (listVM.txt) DO (
		START /B /WAIT VBoxManage unregistervm %%j
		ECHO Maquina %%i desregistrada
	)
	:: Desregistra las maquinas que se dejaron en el txt

	DEL listVM.txt
GOTO:EOF

:modifyVM
	SETLOCAL enableextensions enabledelayedexpansion
	CALL:instructions
	CLS
	ECHO.
	ECHO ************************************
	ECHO * Modificacion de parametros de VM *
	ECHO ************************************
	ECHO.
	
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
			ECHO RAM de la maquina %%i cambiado a !numberRAM!
		)
		PAUSE
		CALL:queHacerModifyVM
	)
	
	IF ERRORLEVEL 4 (
	:: Modificar la memoria grafica
		ECHO.
		ECHO Pon el numero de megas de memoria grafica
		SET /P numberVRAM="Ten en cuenta la memoria grafica de tu ordenador y que el maximo 256 MB: "
		FOR /F "tokens=1,2 delims= " %%i IN (listVM.txt) DO (
			START /B /WAIT VBoxManage modifyvm %%j --vram !numberVRAM!
			ECHO VRAM de la maquina %%i cambiado a !numberVRAM!
		)
		PAUSE
		CALL:queHacerModifyVM
	)
	
	IF ERRORLEVEL 3 (
	:: Cambiar el numero de nucleos virtuales
		ECHO.
		ECHO Pon el numero de nucleos virtuales de las maquinas
		SET /P numberCPU="Ten en cuenta el numero de nucleos de tu ordenador: "
		FOR /F "tokens=1,2" %%i IN (listVM.txt) DO (
			START /B VBoxManage modifyvm %%j --cpus !numberCPU!
			ECHO Nucleos de la maquina %%i cambiado a !numberCPU!
		)
		PAUSE
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
			ECHO Tamano del disco %%i aumentado a !megasModifymedium!
		)
		:: Redimensiona los discos seleccionados
		PAUSE
		CLS
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

:unattendedInstallVM
	CALL:instructions
	CLS
	ECHO.
	ECHO ***************************
	ECHO * Instalacion desatendida *
	ECHO ***************************
	ECHO.
	ECHO Ahora se abrira un archivo de texto con todas la VM registradas que hay en el momento, deja UNICAMENTE la que se instalara de forma desatendida.
	PAUSE
	
	START /B /WAIT VBoxManage list vms >> listVM.txt
	START listVM.txt
	PAUSE
	
	ECHO Ahora se procedera con la creacion de un archivo .xml que instalara de forma desatendida la maquina virtual para la que se configure
	ECHO Escoge cuidadosamente los valores que se te iran preguntando
	ECHO.
	
	SET /P iso="Pon la localizacion de la ISO: "
	SET /P user="Nombre de usuario: "
	SET /P password="Contrasena del usuario: "
	::SET /P fullUserName="Pon la localizacion de la ISO: "
	::SET /P keyProduct="Clave del producto: " --key=%keyProduct%
	::SET /P country="Codigo de dos letras de tu pais: "
	SET /P hostname="Nombre FQDN del ordenador: "
	
	FOR /F "tokens=1,2" %%i IN (listVM.txt) DO (
		START /B /WAIT VBoxManage unattended install %%i --iso="%iso%" --user=%user% --password=%password% --full-user-name=%user% --no-install-additions --locale=es_ES --country=ES --time-zone=ES --hostname=%hostname%
	)
	DEL listVM.txt
	
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
	
	ECHO  I. Hacer una instalacion desatendida
	ECHO  m. Modificar la configuracion de maquinas virtuales
	ECHO  l. Listar las maquinas registradas
	ECHO  d. Desregistrar maquinas con estado inaccesible
	ECHO  D. Desregistrar maquinas que se seleccionen
	ECHO  e. Exportar una o varias VM a ova
	ECHO  r. Registrar en VirtualBox nuevas VM
	ECHO  s. Sacar una snapshot o instantanea de una o varias maquinas
	ECHO  S. Salir

	CHOICE /C SsreDdlmI /CS /M "Pulsa la letra de la opcion deseada"
	:: Se escoge la opcion deseada, que redirigira al errorlevel correspondiente
	
	IF ERRORLEVEL 9 (
	:: Instalacion desatendida
		CLS
		CALL:unattendedInstallVM
		CALL:escogerOtraVez
	)

	IF ERRORLEVEL 8 (
	:: Modificar las caracteristicas de VM
		CLS
		CALL:modifyVM
		CALL:escogerOtraVez
	)
	
	IF ERRORLEVEL 7 (
	:: Listar VM
		CLS
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