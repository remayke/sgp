@echo off
setlocal enabledelayedexpansion

:: SGP - Versao 1.2


echo.
echo ###################
echo     RODANDO SGP
echo ###################
echo.




echo Inicializando SGP
del Diretor.dat
(
    echo.%CD%
    echo.
    set /a "lastYear=!date:~-4! - 1"
    echo.!lastYear!
) > Diretor.dat

if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo.




echo Rodando Laymod.exe
start /wait Laymod.exe
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo ok..
echo.




echo Rodando Recalibra.exe
start /wait Recalibra.exe
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo ok..
echo.




echo Rodando ProjetoRede.exe
start /wait ProjetoRede.exe
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo ok..
echo.




echo Rodando Diags.exe
start /wait Diags.exe
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo ok..
echo.




echo Rodando Otimiza.ps1
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { if (Test-Path '.\Otimiza.ps1') { .\Otimiza.ps1; if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE } } else { Write-Error 'Otimiza.ps1 not found'; exit 1 } }"
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo ok..
echo.




echo Rodando Prioriza.exe
start /wait Prioriza.exe
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo ok..
echo.




echo Rodando Sol.exe
start /wait Sol.exe
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo ok..
echo.




echo Rodando Estrategia.ps1
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { if (Test-Path '.\Estrategia.ps1') { .\Estrategia.ps1; if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE } } else { Write-Error 'Estrategia.ps1 not found'; exit 1 } }"
if %errorlevel% neq 0 (
    echo Erro durante a execucao. Finalizando script...
    goto EndScript
)
echo ok..
echo.




echo.
echo #####################################
echo    Finalizando script com SUCESSO!
echo #####################################

:EndScript
endlocal
pause
exit /B %errorlevel%