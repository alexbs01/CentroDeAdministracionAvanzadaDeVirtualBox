@ECHO OFF&call:primerInicio&goto:EOF
:: El programa comienza en la etiqueta "primerInicio"

:escogerOtraVez
:: Funcion que se usara cuando se escoja una opcion a realizar
	PAUSE
	CLS
	GOTO inicio
GOTO:EOF
:: "GOTO:EOF" indica el fin de la funcion

:primerInicio
:: Con el primer inicio del programa mostrara el titulo inicial y añadira al path la ruta de VirtualBox
	CALL .\informacion\initialTitle.bat
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
		CALL .\funcionalidades\unregisterInaccessibleVM.bat
		CALL:escogerOtraVez
	)

	IF ERRORLEVEL 5 (
	:: Desregistrar VM que se deseen
		CLS
		CALL .\funcionalidades\unregisterVM.bat
		CALL:escogerOtraVez
	)

	IF ERRORLEVEL 4 (
	:: Exportar a ova la VM que se seleccionen
		CLS
		CALL .\funcionalidades\exportOvaVM.bat
		CALL:escogerOtraVez
	)

	IF ERRORLEVEL 3 (
	:: Registrar VM
		CLS
		CALL .\funcionalidades\registerVM.bat
		CALL:escogerOtraVez
	)

	IF ERRORLEVEL 2 (
	:: Hacer una snapshot de las VM
		CLS
		CALL .\funcionalidades\snapshotVM.bat
		CALL:escogerOtraVez
	)

	IF ERRORLEVEL 1 EXIT

	GOTO inicio
