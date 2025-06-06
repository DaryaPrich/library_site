[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$AppName = "main"
$ProjectDir = "library_site"

# 1. Проверка и добавление main в INSTALLED_APPS
$settingsPath = "$ProjectDir\settings.py"
$settingsContent = Get-Content $settingsPath -Raw

if ($settingsContent -notmatch "'$AppName'") {
    Write-Host "📦 Добавляю '$AppName' в INSTALLED_APPS..."
    $settingsContent = $settingsContent -replace "(INSTALLED_APPS\s*=\s*\[)", "`$1`n    '$AppName',"
    Set-Content $settingsPath $settingsContent
} else {
    Write-Host "✅ '$AppName' уже есть в INSTALLED_APPS."
}

# 2. Создание index.html
$templatePath = "$AppName\templates\$AppName"
New-Item -ItemType Directory -Path $templatePath -Force | Out-Null
$indexFile = "$templatePath\index.html"

@"
<!DOCTYPE html>
<html lang=""ru"">
<head>
    <meta charset=""UTF-8"">
    <title>Библиотека</title>
</head>
<body>
    <h1>Добро пожаловать в библиотеку!</h1>
    <p>Это главная страница сайта Дарьи Причисловой.</p>
</body>
</html>
"@ | Set-Content -Encoding UTF8 $indexFile

Write-Host "📝 Создан файл шаблона: $indexFile"

# 3. Добавление views.py
$viewsFile = "$AppName\views.py"
$viewsContent = Get-Content $viewsFile -Raw

if ($viewsContent -notmatch "def index") {
    Add-Content $viewsFile "`n`nfrom django.shortcuts import render`n`ndef index(request):`n    return render(request, '$AppName/index.html')"
    Write-Host "🧠 Добавлено представление index() в $viewsFile"
} else {
    Write-Host "✅ Представление index() уже есть в $viewsFile"
}

# 4. Настройка urls.py
$urlsFile = "$ProjectDir\urls.py"
$urlsContent = Get-Content $urlsFile -Raw

if ($urlsContent -notmatch "path\('',") {
    Write-Host "🔗 Настраиваю маршруты в $urlsFile"

    if ($urlsContent -notmatch "from main import views") {
        $urlsContent = $urlsContent -replace "(from django.urls import path)", "`$1`nfrom main import views"
    }

    $urlsContent = $urlsContent -replace "(urlpatterns\s*=\s*\[)", "`$1`n    path('', views.index, name='index'),"
    Set-Content $urlsFile $urlsContent
} else {
    Write-Host "✅ URL '/' уже прописан в $urlsFile"
}

Write-Host "`n🚀 Готово! Запускаю сервер Django..."
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd `"$PWD`"; .\venv\Scripts\Activate.ps1; python manage.py runserver"

Write-Host "`n🚀 Готово! Теперь запусти:"
Write-Host "   python manage.py runserver"
Write-Host "и открой http://127.0.0.1:8000/"
