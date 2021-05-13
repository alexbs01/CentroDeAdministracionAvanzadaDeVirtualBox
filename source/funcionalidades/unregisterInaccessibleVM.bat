@ECHO OFF

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

