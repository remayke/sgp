##
# Otimiza - v1.0.1
##
Start-Sleep -Seconds 1

# Set the ErrorActionPreference to Stop to ensure that any errors are treated as terminating errors
$ErrorActionPreference = "Stop"

$casosDat = "Casos.dat"
$logFilePath = "./Logs/Log.dat"


try {
    $json = Get-Content -Path 'otimiza.json' -Raw | ConvertFrom-Json

    $ativo = $json.ativo
    if (!$ativo) {
        Add-Content -Path $logFilePath -Value $("""[" + (Get-Date -Format "MM-dd-yyyy HH:mm:ss") + "] [OTIMIZA] OK - Otimiza desativado""")
        exit 0
    }

    $nPassos = $json.numeroPassos
    $ppMin = $json.periodoProjetoMin
    $ppMax = $json.periodoProjetoMax
    $ncMin = $json.nivelConfiabilidadeMin
    $ncMax = $json.nivelConfiabilidadeMax
    $psiMin = $json.psimin
    $psiMax = $json.psimax
    $sciMin = $json.scimin
    $sciMax = $json.scimax
    $atrMin = $json.atrMin
    $atrMax = $json.atrMax

    $passoPP = ($ppMax - $ppMin) / $nPassos
    $passoNC = ($ncMax - $ncMin) / $nPassos
    $passoPSI = ($psiMax - $psiMin) / $nPassos
    $passoSCI = ($sciMax - $sciMin) / $nPassos
    $passoATR = ($atrMax - $atrMin) / $nPassos
    $totalPassos = [Math]::Pow(($nPassos+1), 3)

    $diagsExe = ".\Diags.exe"
    $casoOtdat = "Calc\CasoOt.dat"

    $csv = "Calc\Otimiza.csv"
    if (Test-Path $csv) {
        Remove-Item $csv -Force
    }
    Set-Content -Path $csv -Value "PP (anos), PSIt, SCIt, ATRt, Nc (%), PSI (medio), SCI (medio), ATR_mm (medio), Custo (R$), Ue"


    if (Test-Path $casosDat) {
        Remove-Item $casosDat -Force
    }
    Set-Content -Path $casosDat -Value "Otimiza"


    $count = 0
    for ($i = 1; $i -le ($nPassos + 1); $i++) {
        $pp = $ppMin + ($i - 1) * $passoPP

        for ($j = 1; $j -le ($nPassos + 1); $j++) {
            $psi = $psiMin + ($j - 1) * $passoPSI
            $sci = $sciMin + ($j - 1) * $passoSCI
            $atr = $atrMin + ($j - 1) * $passoATR

            for ($k = 1; $k -le ($nPassos + 1); $k++) {
                $count++
                $nc = $ncMin + ($k - 1) * $passoNC

                if (Test-Path $casoOtdat) {
                    Remove-Item $casoOtdat -Force
                }
                Set-Content -Path $casoOtdat -Value $pp, $psi, $sci, $atr, $nc, $("$count/$totalPassos")

                Start-Process -FilePath $diagsExe -Wait
                $logContent = Get-Content -Path $logFilePath
                if ($logContent -match 'ERRO') {
                    throw "Diags.exe failed - Foi registrado um erro no log"
                }

            }
        }
    }


    Add-Content -Path $logFilePath -Value $("""[" + (Get-Date -Format "MM-dd-yyyy HH:mm:ss") + "] [OTIMIZA] OK""")
    exit 0


} catch {

    Add-Content -Path $logFilePath -Value $("""[" + (Get-Date -Format "MM-dd-yyyy HH:mm:ss") + "] [OTIMIZA] ERROR $_""")
    exit 500


} finally {
    if (Test-Path $casosDat) {
        Remove-Item $casosDat -Force
    }
    Set-Content -Path $casosDat -Value "NAM"
}