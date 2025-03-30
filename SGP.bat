@echo off
setlocal enabledelayedexpansion



echo.
echo #################################
echo        RODANDO SGP  v2.0
echo #################################
echo.




@REM ===============================================================
echo Configurando e validando pastas "%~dp0"
:: Change to the script directory
cd /d "%~dp0"
echo.

if not exist "%~dp0Laymod.exe" (
    echo Erro: "%~dp0Laymod.exe" nao encontrado! && ::EndScript
)

if not exist "%~dp0Recalibra.exe" (
    echo Erro: "%~dp0Recalibra.exe" nao encontrado! && ::EndScript
)

if not exist "%~dp0ProjetoRede.exe" (
    echo Erro: "%~dp0ProjetoRede.exe" nao encontrado! && ::EndScript
)

if not exist "%~dp0Diags.exe" (
    echo Erro: "%~dp0Diags.exe" nao encontrado! && ::EndScript
)

if not exist "%~dp0Otimiza.ps1" (
    echo Erro: "%~dp0Otimiza.ps1" nao encontrado! && ::EndScript
)

if not exist "%~dp0Prioriza.exe" (
    echo Erro: "%~dp0Prioriza.exe" nao encontrado! && ::EndScript
)

if not exist "%~dp0Sol.exe" (
    echo Erro: "%~dp0Sol.exe" nao encontrado! && ::EndScript
)

if not exist "%~dp0Estrategia.ps1" (
    echo Erro: "%~dp0Estrategia.ps1" nao encontrado! && ::EndScript
)
@REM ===============================================================



@REM ===============================================================
echo Configurando Diretor.dat

:: Define paths
set "DiretorFile=%~dp0Diretor.dat"
set "TempFile=%~dp0temp.dat"

:: Create a temporary file with the new Diretor.dat first lines
(
    echo %CD%
    echo.
) > "%TempFile%"

if exist "%DiretorFile%" (
    :: Use "usebackq" to correctly retrieve the year from the previously Diretor.dat
    for /f "usebackq skip=1 delims=" %%i in ("%DiretorFile%") do echo %%i >> "%TempFile%"

) else (
    :: Copy the lastYear into the TempFile
    set /a "lastYear=!date:~-4! - 1"
    >> "%TempFile%" echo.!lastYear!
)

:: Replace Diretor.dat with the modified temp.dat
move /y "%TempFile%" "%DiretorFile%" > nul

:: Check for errors in the move command
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo.
@REM ===============================================================



@REM ===============================================================
echo Rodando "%~dp0Laymod.exe"
"%~dp0Laymod.exe"
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo ok..
echo.
@REM ===============================================================



@REM ===============================================================
echo Rodando "%~dp0Recalibra.exe"
"%~dp0Recalibra.exe"
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo ok..
echo.
@REM ===============================================================



@REM ===============================================================
echo Rodando "%~dp0ProjetoRede.exe"
"%~dp0ProjetoRede.exe"
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo ok..
echo.
@REM ===============================================================



@REM ===============================================================
echo Rodando "%~dp0Diags.exe"
"%~dp0Diags.exe"
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo ok..
echo.
@REM ===============================================================



@REM ===============================================================
echo Rodando "%~dp0Otimiza.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Otimiza.ps1"
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo ok..
echo.
@REM ===============================================================



@REM ===============================================================
echo Rodando "%~dp0Prioriza.exe"
"%~dp0Prioriza.exe"
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo ok..
echo.
@REM ===============================================================



@REM ===============================================================
echo Rodando "%~dp0Sol.exe"
"%~dp0Sol.exe"
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo ok..
echo.
@REM ===============================================================



@REM ===============================================================
echo Rodando Estrategia.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Estrategia.ps1"
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo ok..
echo.
@REM ===============================================================



echo.
echo #################################
echo     Fim da rotina com SUCESSO
echo #################################



@REM ===============================================================

:: End of the script
:EndScript
endlocal
pause
exit /B %errorlevel%