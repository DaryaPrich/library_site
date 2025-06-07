# run_server.ps1 (лежит в корне ДарьяПричислова.Библиотека)

$projectDir = Join-Path $PSScriptRoot "library_site"
$venvActivate = Join-Path $projectDir "venv\Scripts\Activate.ps1"
$managePath = Join-Path $projectDir "manage.py"

if (-not (Test-Path $venvActivate)) {
    Write-Host "❌ Виртуальное окружение не найдено: $venvActivate" -ForegroundColor Red
    exit 1
}

Set-Location $projectDir
. $venvActivate  # Важно: точка перед вызовом — запускает в текущем контексте

Write-Host "🚀 Запускаю Django-сервер..." -ForegroundColor Cyan
python manage.py runserver
