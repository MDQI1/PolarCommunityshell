# Check Windows Edition
$edition = (Get-CimInstance Win32_OperatingSystem).Caption
Write-Host "Detected System: $edition" -ForegroundColor Cyan

# Function to safely set registry keys
function Set-RegistryKey {
    param (
        [string]$Path,
        [string]$Name,
        [int]$Value,
        [string]$Description
    )
    if (!(Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
        Write-Host "Created Path: $Path" -ForegroundColor DarkGray
    }
    Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type DWord
    Write-Host "Applied: $Description" -ForegroundColor Green
    Write-Host "   -> Path: $Path" -ForegroundColor Gray
    Write-Host "   -> Value: $Name = $Value" -ForegroundColor Gray
    Write-Host "------------------------------------------------------"
}

if ($edition -match "Pro" -or $edition -match "Enterprise" -or $edition -match "Education") {
    Write-Host "Mode: Windows Pro (Local Security Policy / Group Policy)" -ForegroundColor Yellow
    Write-Host "------------------------------------------------------"

    # 1) Computer Configuration > Administrative Templates > Windows Components > Windows Update > Manage End user experience
    #    Configure Automatic Updates = Disabled
    Set-RegistryKey -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" `
                    -Name "NoAutoUpdate" `
                    -Value 1 `
                    -Description "1) Configure Automatic Updates = Disabled"

    # 2) Computer Configuration > Administrative Templates > Windows Components > Delivery Optimization
    #    Download Mode = Bypass (100)
    Set-RegistryKey -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" `
                    -Name "DODownloadMode" `
                    -Value 100 `
                    -Description "2) Delivery Optimization > Download Mode = Bypass (100)"

} elseif ($edition -match "Home") {
    Write-Host "Mode: Windows Home (Regedit)" -ForegroundColor Yellow
    Write-Host "------------------------------------------------------"

    # HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU
    # Create Keys: WindowsUpdate, AU (handled by function)
    # Value: NoAutoUpdate = 1
    Set-RegistryKey -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" `
                    -Name "NoAutoUpdate" `
                    -Value 1 `
                    -Description "Regedit > WindowsUpdate > AU > NoAutoUpdate = 1"

} else {
    Write-Host "Unknown Edition ($edition). Applying Safe Home Logic..." -ForegroundColor Magenta
    Set-RegistryKey -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" `
                    -Name "NoAutoUpdate" `
                    -Value 1 `
                    -Description "Fallback: NoAutoUpdate = 1"
}

Write-Host "Done." -ForegroundColor Cyan
pause
