@echo off
REM subroutines to get and change powerscheme in PC
SETLOCAL EnableDelayedExpansion

REM ========= Main ==========
Call :get_current_pwrscheme var_saved_pwrscheme
echo Current Power Scheme: %var_saved_pwrscheme%

Call :get_performanceGUID var_performanceGUID
echo Power: %var_performanceGUID%

Call :set_powercfg %var_performanceGUID%

pause

Call :set_powercfg %var_saved_pwrscheme%

goto end_program

REM ========= Get current powerscheme GUID =========
:get_current_pwrscheme
    for /f "tokens=4 delims= " %%i in ('powercfg /GetActiveScheme') DO (
      set %1=%%i
    )
goto :eof

REM ========= Get Peformance powerscheme GUID =========
:get_performanceGUID
    for /f "tokens=3,4,* delims= " %%i in ('powercfg /L') DO (
       if "%%i"=="GUID:" (
           set tmp=%%k
           if not "!tmp!"=="!tmp:performance=!" (
               set %1=%%j
           )
       )
    )
goto :eof

REM ========= Set powerscheme GUID =========
:set_powercfg
    powercfg /setactive %1
goto :eof

:end_program
pause
exit /b