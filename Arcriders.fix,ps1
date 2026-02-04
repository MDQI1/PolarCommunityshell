# Check Windows Edition
$edition = (Get-CimInstance Win32_OperatingSystem).Caption

Write-Host "Detected System: $edition" -ForegroundColor Cyan

if ($edition -match "Pro" -or $edition -match "Enterprise") {
    Write-Host "Windows Pro/Enterprise detected. Applying Delivery Optimization settings..." -ForegroundColor Yellow
    
    # Path for Delivery Optimization
    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
    
    # Create the key if it doesn't exist
    if (!(Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Host "Created registry key: $registryPath" -ForegroundColor Green
    }
    
    # Set Download Mode to Bypass (100)
    Set-ItemProperty -Path $registryPath -Name "DODownloadMode" -Value 100 -Type DWord
    Write-Host "Success: Download Mode set to Bypass (100)." -ForegroundColor Green

} elseif ($edition -match "Home") {
    Write-Host "Windows Home detected. Applying Windows Update settings..." -ForegroundColor Yellow
    
    # Path for Windows Update AU
    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    
    # Create the key if it doesn't exist (recursively creates WindowsUpdate if needed)
    if (!(Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Host "Created registry key: $registryPath" -ForegroundColor Green
    }
    
    # Set NoAutoUpdate to 1
    Set-ItemProperty -Path $registryPath -Name "NoAutoUpdate" -Value 1 -Type DWord
    Write-Host "Success: NoAutoUpdate set to 1." -ForegroundColor Green
    
} else {
    Write-Host "Could not determine if Pro or Home, or edition not supported by this script." -ForegroundColor Red
}

Write-Host "Done." -ForegroundColor Cyan
pause
