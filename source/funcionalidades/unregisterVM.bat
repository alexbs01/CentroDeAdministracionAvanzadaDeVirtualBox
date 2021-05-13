@ECHO OFF

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
PAUSE
