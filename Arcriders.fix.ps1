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
    Write-Host "Windows Pro/Enterprise detected." -ForegroundColor Yellow
    Write-Host "Applying Group Policy settings via Registry..." -ForegroundColor Yellow
    
    # 1. Path: Windows Components > Windows Update > Manage End user experience
    # Setting: Configure Automatic Updates = Disabled
    # Registry Equivalent: NoAutoUpdate = 1
    Write-Host "1. Disabling Automatic Updates (Manage End user experience)..."
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1

    # 2. Path: Windows Components > Delivery Optimization
    # Setting: Download Mode = Bypass (100)
    # Registry Equivalent: DODownloadMode = 100
    Write-Host "2. Setting Delivery Optimization Download Mode to Bypass..."
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" -Name "DODownloadMode" -Value 100

} elseif ($edition -match "Home") {
    Write-Host "Windows Home detected." -ForegroundColor Yellow
    
    # Home Edition usually doesn't have GP, so we use Registry directly as requested.
    # Registry: HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU
    # Value: NoAutoUpdate = 1
    Write-Host "Applying Registry Fix for Home Edition..."
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1

} else {
    Write-Host "Could not determine if Pro or Home. Applying safe fallback (Disable Auto Update)..." -ForegroundColor Magenta
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1
}

Write-Host "Optimization Applied Successfully." -ForegroundColor Cyan
pause
