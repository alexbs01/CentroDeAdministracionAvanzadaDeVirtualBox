@ECHO OFF

VBoxManage list vms >> listVM.txt
START listVM.txt
PAUSE

FOR /F "tokens=1,2" %%i IN (listVM.txt) DO (
	START /B /WAIT VBoxManage unregistervm %%j
)

ECHO.
ECHO ***************************************************
ECHO * Maquinas virtuales inaccesibles desregistradas. *
ECHO ***************************************************

DEL .txt
PAUSE
..\main.bat