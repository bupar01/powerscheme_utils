@echo off
REM subroutines to get and change powerscheme in PC
SETLOCAL EnableDelayedExpansion

REM ========= Main ==========
Call :get_current_pwrscheme var_saved_pwrscheme
echo Current Power Scheme: %var_saved_pwrscheme%

Call :get_powerschemeGUIDs var_performanceGUID var_balancedGUID var_PsaverGUID
echo GUID for Performance: %var_performanceGUID%
echo GUID for Balanced: %var_balancedGUID%
echo GUID for Saver: %var_PsaverGUID%

pause

echo Switching to Performance mode...
Call :set_powercfg %var_performanceGUID%

pause

echo Switching to Power Saver mode...
Call :set_powercfg %var_PsaverGUID%

pause

echo Switching to Balanced Power mode...
Call :set_powercfg %var_balancedGUID%

pause

echo Returning to original power mode...
Call :set_powercfg %var_saved_pwrscheme%

goto end_program

REM ========= Get current powerscheme GUID =========
:get_current_pwrscheme
    for /f "tokens=4 delims= " %%i in ('powercfg /GetActiveScheme') DO (
      set %1=%%i
    )
goto :eof

REM ========= Get powerscheme GUIDs =========
:get_powerschemeGUIDs
    for /f "tokens=3,4,* delims= " %%i in ('powercfg /L') DO (
       if "%%i"=="GUID:" (
           set tmp=%%k
           if not "!tmp!"=="!tmp:performance=!" (
               set %1=%%j
           )
           if not "!tmp!"=="!tmp:Balanced=!" (
               set %2=%%j
           )
           if not "!tmp!"=="!tmp:saver=!" (
               set %3=%%j
           )
       )
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

REM ========= Get Power Saver powerscheme GUID =========
:get_PsaverGUID
    for /f "tokens=3,4,* delims= " %%i in ('powercfg /L') DO (
       if "%%i"=="GUID:" (
           set tmp=%%k
           if not "!tmp!"=="!tmp:saver=!" (
               set %1=%%j
           )
       )
    )
goto :eof

REM ========= Get Balanced powerscheme GUID =========
:get_PBalancedGUID
    for /f "tokens=3,4,* delims= " %%i in ('powercfg /L') DO (
       if "%%i"=="GUID:" (
           set tmp=%%k
           if not "!tmp!"=="!tmp:Balanced=!" (
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