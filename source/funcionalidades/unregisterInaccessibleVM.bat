@ECHO OFF

CHOICE /M "Estas seguro que quieres desregistrar las VM inaccesibles?"

IF ERRORLEVEL 2 GOTO fin

IF ERRORLEVEL 1 (

	START /B /WAIT VBoxManage list vms >> listVM.txt

	FINDSTR "\<\<.*\>\>" listVM.txt >> onlyVMUnregister.txt

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
PAUSE

