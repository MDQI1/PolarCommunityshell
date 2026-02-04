# Check Windows Edition
$edition = (Get-CimInstance Win32_OperatingSystem).Caption

Write-Host "Detected System: $edition" -ForegroundColor Cyan

# Function to set registry value safely
function Set-RegistryValue {
    param (
        [string]$Path,
        [string]$Name,
        [int]$Value
    )
    if (!(Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
        Write-Host "Created key: $Path" -ForegroundColor Green
    }
    Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type DWord
    Write-Host "Set $Name = $Value at $Path" -ForegroundColor Green
}

if ($edition -match "Pro" -or $edition -match "Enterprise" -or $edition -match "Education") {
    Write-Host "Windows Pro/Enterprise detected. Applying strict settings..." -ForegroundColor Yellow
    
    # 1. Windows Update > Manage End user experience > Configure Automatic Updates = Disabled
    # Registry: HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -> NoAutoUpdate = 1
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1

    # 2. Delivery Optimization > Download Mode = Bypass (100)
    # Registry: HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization -> DODownloadMode = 100
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" -Name "DODownloadMode" -Value 100

} elseif ($edition -match "Home") {
    Write-Host "Windows Home detected. Applying Windows Update settings..." -ForegroundColor Yellow
    
    # HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -> NoAutoUpdate = 1
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1

} else {
    Write-Host "Could not determine if Pro or Home. Applying standard Windows Update block (Safe Fallback)..." -ForegroundColor Magenta
    # Fallback: Apply the Home fix as it is the most common request for blocking updates
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1
}

Write-Host " Optimization Applied Successfully." -ForegroundColor Cyan
pause
