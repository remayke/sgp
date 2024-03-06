##
# Estrategia - v1.0.0
##

# Find all Estrateg files matching the pattern "Estrateg_*-Config.dat"
$paramDat = ".\Params.dat"
$logFilePath = "./Logs/Log.dat"
$estrategExe = ".\Estrateg.exe"
$comparaExe = ".\Compara.exe"
$configDatFilePath = "./Config.dat"
$files = Get-ChildItem -Path "./" -Filter "Estrateg_*-Config.dat"

# Read the PA
try {
    $pa = Get-Content -Path $paramDat | Select-Object -Index 1
    $pa = [int]$pa  # Convert to integer
} catch {
    $pa = 10  # Default value in case of exception
}

# Loop through Estrategia
foreach ($file in $files) {
    # Extract the number from the filename using regex
    if ($file.Name -match "Estrateg_(\d+)-Config.dat") {
        $numeroEstrategia = $matches[1]

        # Removes the original Config.dat file
        if (Test-Path $configDatFilePath) {
            Remove-Item $configDatFilePath -Force
        }

        # Altera o arquivo de configuração para rodar o Estrateg.exe
        Copy-Item $file.FullName $configDatFilePath

        # Deleta os arquivos de resultados antigos
        $specificFolderPath = "./Calc/Estrat_$numeroEstrategia"
        if (Test-Path $specificFolderPath) {
            Get-ChildItem -Path $specificFolderPath -File | Where-Object { $_.Name -ne "RESTR.csv" -and $_.Name -ne "PROGRAMA.csv" } | Remove-Item -Force
        } else {
            New-Item -ItemType Directory -Path $specificFolderPath
        }

        # Gerar os arquivos iniciais novamente
        $file1Path  = Join-Path -Path $specificFolderPath -ChildPath "CasosEstrateg.dat"
        if (-not (Test-Path -Path $file1Path)) {
            New-Item -ItemType File -Path $file1Path | Out-Null
        }

        $file2Path  = Join-Path -Path $specificFolderPath -ChildPath "Concl_Estrateg.dat"
        if (-not (Test-Path -Path $file2Path)) {
            New-Item -ItemType File -Path $file2Path | Out-Null
        }

        $folderPath = Join-Path -Path $specificFolderPath -ChildPath "Params"
        if (-not (Test-Path -Path $folderPath)) {
            New-Item -ItemType Directory -Path $folderPath | Out-Null
        }

        for ($i = 1; $i -le $pa; $i++) {
            # Define the file name
            $fileName = "PPI_Ano $i.csv"
            $filePath = Join-Path -Path $specificFolderPath -ChildPath $fileName
            $content = @(
                '"ANO","ID_SNV","Rodovia","Inicio","Final","Acost.LE","HRacLE","hcLE","Faixa 1","hc1","HR1","Faixa 2","hc2","HR2","Faixa 3","hc3","HR3","Faixa 4","hc4","HR4","Acost.LD","HRacLD","hcLD"',
                '"","","","(km)","(km)","","(cm)","(cm)","","(cm)","(cm)","","(cm)","(cm)","","(cm)","(cm)","","(cm)","(cm)","","(cm)","(cm)"'
            )
            $content | Out-File -FilePath $filePath -Encoding UTF8
        }


        $qtPista = "QT_Pista_Brasil.csv"
        $qtPistaPath = Join-Path -Path $specificFolderPath -ChildPath $qtPista
        $content = @('"Ano","Reparos","Fresagem","CP","Pintura","Reperfilagem","CBUQ","CBUQpol","Remocao","Escarificacao e Recompactacao","Imprimacao","BG","Prep. do Subleito","Drenos","CCP","RSLGJ","B&S","TSDqb","TSDpol","Custo"',
        '"","(m2)","(m3)","(m3)","(m2)","(m3)","(m3)","(m3)","(m3)","(m3)","(m2)","(m3)","(m2)","(m)","(m3)","(m)","(m2)","(m3)","(m3)","(R$)"'
        )

        $content | Out-File -FilePath $qtPistaPath -Encoding UTF8


        Start-Process -FilePath $estrategExe -Wait
        $logContent = Get-Content -Path $logFilePath
        if ($logContent -match 'ERRO') {
            throw "Estrateg.exe failed - Foi registrado um erro no log"
        }


        Start-Process -FilePath $comparaExe -Wait
        $logContent = Get-Content -Path $logFilePath
        if ($logContent -match 'ERRO') {
            throw "Compara.exe failed - Foi registrado um erro no log"
        }


    }
}
