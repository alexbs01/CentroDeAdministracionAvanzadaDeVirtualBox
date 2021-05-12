@ECHO OFF&call:primerInicio&goto:EOF

:escogerOtraVez
	PAUSE
	CLS
	GOTO inicio
GOTO:EOF

:primerInicio
	CALL .\informacion\initialTitle.bat
	SET PATH=%PATH%;C:\Program Files\Oracle\VirtualBox

:inicio
	ECHO.
	ECHO  Escoge que operacion deseas realizar.
	ECHO.

	ECHO  l. Listar las maquinas registradas
	ECHO  d. Desregistrar maquinas con estado inaccesible
	ECHO  D. Desregistrar maquinas que se seleccionen
	ECHO  e. Exportar una o varias VM a ova
	ECHO  r. Registrar en Virtual Box nuevas VM
	ECHO  s. Sacar una snapshot o instantanea de una o varias maquinas
	ECHO  S. Salir

	CHOICE /C SsreDdl /CS /M "Pulsa la letra de la opcion deseada"

	IF ERRORLEVEL 7 (
		ECHO.
		START /B /WAIT vboxmanage list vms
		CALL:escogerOtraVez
	)	
		
	IF ERRORLEVEL 6 (
		CLS
		CALL .\funcionalidades\unregisterInaccessibleVM.bat
		CALL:escogerOtraVez
	)

	IF ERRORLEVEL 5 (
		CLS
		CALL .\funcionalidades\unregisterVM.bat
		CALL:escogerOtraVez
	)

	IF ERRORLEVEL 4 (
		CLS
		CALL .\funcionalidades\exportOvaVM.bat
		CALL:escogerOtraVez
	)

	IF ERRORLEVEL 3 (
		CLS
		CALL .\funcionalidades\registerVM.bat
		CALL:escogerOtraVez
	)

	IF ERRORLEVEL 2 (
		CLS
		CALL .\funcionalidades\snapshotVM.bat
		CALL:escogerOtraVez
	)

	IF ERRORLEVEL 1 EXIT

	GOTO inicio

::C:\Users\alexb\Desktop\Cosas\proyectosGit\proyectoDeFinDeCursoDeASIR\source