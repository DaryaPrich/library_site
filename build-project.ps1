[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

Clear-Host

$projectFolder = "library_site"
$scriptDir = "$PSScriptRoot\scripts"
$projectRoot = Join-Path $PSScriptRoot $projectFolder
$venvPath = Join-Path $projectRoot "venv"

# [1] Убедимся, что папка проекта существует
if (-not (Test-Path $projectRoot)) {
    Write-Host "📂 Создаю папку '$projectFolder'..."
    New-Item -ItemType Directory -Path $projectRoot | Out-Null
} else {
    Write-Host "📁 Папка проекта '$projectFolder' уже существует"
}

# [2] Переход в папку проекта
Write-Host "🚀 Переход в папку проекта: $projectRoot"
Set-Location $projectRoot

# [3] Создание виртуального окружения
if (-not (Test-Path $venvPath)) {
    Write-Host "📦 Создаю виртуальное окружение..."
    python -m venv venv
}

# [4] Активация виртуального окружения
Write-Host "🔁 Активирую виртуальное окружение..."
& "$venvPath\Scripts\Activate.ps1"

# [5] Установка зависимостей
Write-Host "⬇ Устанавливаю Django и Pillow..."
pip install --upgrade pip | Out-Null
pip install django pillow | Out-Null

# [6] Функция запуска вспомогательных скриптов
function Run-Script {
    param ([string]$path)
    Write-Host "`n▶ Запуск: $path" -ForegroundColor Yellow
    try {
        & $path
        Write-Host "✅ Успешно: $path" -ForegroundColor Green
    } catch {
        Write-Host "❌ Ошибка в: $path" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor DarkRed
        exit 1
    }
}

# [7] Запуск по шагам
Run-Script "$scriptDir\init-django-inplace.ps1"
Run-Script "$scriptDir\fix-urls-include.ps1"
Run-Script "$scriptDir\generate-library-structure.ps1"
Run-Script "$scriptDir\generate-basic-views.ps1"
Run-Script "$scriptDir\enable-main-view.ps1"

if (Test-Path "$scriptDir\generate-auth.ps1") {
    Run-Script "$scriptDir\generate-auth.ps1"
}
if (Test-Path "$scriptDir\generate-forms.ps1") {
    Run-Script "$scriptDir\generate-forms.ps1"
}
if (Test-Path "$scriptDir\generate-admin-panel.ps1") {
    Run-Script "$scriptDir\generate-admin-panel.ps1"
}

# [8] Запуск сервера
Write-Host "`n🌍 Запускаю сервер..."
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location -LiteralPath `"$projectRoot`"; .\venv\Scripts\Activate.ps1; python manage.py runserver"


Write-Host "`n🎉 Всё готово! Открой http://127.0.0.1:8000/" -ForegroundColor Cyan

# [9] Возврат в исходную папку
Set-Location $PSScriptRoot
Write-Host "`n↩ Возврат в: $PSScriptRoot"
