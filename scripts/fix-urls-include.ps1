[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$UrlsFile = "library_site\urls.py"

Write-Host "🔍 Проверяю наличие include в $UrlsFile..."

$urlsContent = Get-Content $UrlsFile -Raw

if ($urlsContent -notmatch "include") {
    Write-Host "➕ Добавляю 'include' в импорт..."
    $urlsContent = $urlsContent -replace "(from django.urls import path)", "from django.urls import path, include"
    Set-Content $UrlsFile $urlsContent
    Write-Host "✅ Готово! include добавлен"
} else {
    Write-Host "✅ include уже есть, всё ок"
}
