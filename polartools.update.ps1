# Abo-Hassan - Update PolarTools Script
# يحذف المجلد القديم وينزل النسخة الجديدة من GitHub

$pluginPath = "C:\Program Files (x86)\Steam\plugins\PolarTools"
$downloadUrl = "https://github.com/MDQI1/PolarTools/releases/download/v1.8.6/PolarTools_v1.8.6.zip"
$tempZip = "$env:TEMP\PolarTools_v1.8.6.zip"
$pluginsFolder = "C:\Program Files (x86)\Steam\plugins"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Abo-Hassan - PolarTools Updater" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# حذف المجلد القديم
if (Test-Path $pluginPath) {
    Write-Host "[*] جاري حذف PolarTools القديم..." -ForegroundColor Yellow
    try {
        Remove-Item -Path $pluginPath -Recurse -Force
        Write-Host "[+] تم حذف المجلد القديم بنجاح!" -ForegroundColor Green
    }
    catch {
        Write-Host "[!] فشل حذف المجلد: $_" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "[*] المجلد غير موجود، سيتم التنزيل مباشرة..." -ForegroundColor Yellow
}

Write-Host ""

# إنشاء مجلد plugins إذا لم يكن موجوداً
if (-not (Test-Path $pluginsFolder)) {
    New-Item -Path $pluginsFolder -ItemType Directory -Force | Out-Null
}

# تنزيل الملف من GitHub
Write-Host "[*] جاري تنزيل PolarTools من GitHub..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZip -UseBasicParsing
    Write-Host "[+] تم التنزيل بنجاح!" -ForegroundColor Green
}
catch {
    Write-Host "[!] فشل التنزيل: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# فك ضغط الملف
Write-Host "[*] جاري فك الضغط..." -ForegroundColor Yellow
try {
    Expand-Archive -Path $tempZip -DestinationPath $pluginsFolder -Force
    Write-Host "[+] تم فك الضغط بنجاح!" -ForegroundColor Green
}
catch {
    Write-Host "[!] فشل فك الضغط: $_" -ForegroundColor Red
    exit 1
}

# حذف ملف الـ ZIP المؤقت
Remove-Item -Path $tempZip -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   تم تحديث PolarTools بنجاح!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

pause
