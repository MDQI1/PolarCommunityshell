# Abo-Hassan - Update PolarTools Script
# Deletes old folder and downloads new version from GitHub

$pluginPath = "C:\Program Files (x86)\Steam\plugins\PolarTools"
$downloadUrl = "https://github.com/MDQI1/PolarTools/releases/download/v1.8.6/PolarTools_v1.8.6.zip"
$tempZip = "$env:TEMP\PolarTools_v1.8.6.zip"
$pluginsFolder = "C:\Program Files (x86)\Steam\plugins"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Abo-Hassan - PolarTools Updater" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Delete old folder
if (Test-Path $pluginPath) {
    Write-Host "[*] Deleting old PolarTools..." -ForegroundColor Yellow
    try {
        Remove-Item -Path $pluginPath -Recurse -Force
        Write-Host "[+] Old folder deleted successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "[!] Failed to delete folder: $_" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "[*] Folder not found, proceeding to download..." -ForegroundColor Yellow
}

Write-Host ""

# Create plugins folder if it doesn't exist
if (-not (Test-Path $pluginsFolder)) {
    New-Item -Path $pluginsFolder -ItemType Directory -Force | Out-Null
}

# Download file from GitHub
Write-Host "[*] Downloading PolarTools from GitHub..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZip -UseBasicParsing
    Write-Host "[+] Download completed successfully!" -ForegroundColor Green
}
catch {
    Write-Host "[!] Download failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Extract the file
Write-Host "[*] Extracting files..." -ForegroundColor Yellow
try {
    Expand-Archive -Path $tempZip -DestinationPath $pluginsFolder -Force
    Write-Host "[+] Extraction completed successfully!" -ForegroundColor Green
}
catch {
    Write-Host "[!] Extraction failed: $_" -ForegroundColor Red
    exit 1
}

# Delete temporary ZIP file
Remove-Item -Path $tempZip -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   PolarTools updated successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

pause
