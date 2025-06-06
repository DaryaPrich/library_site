param (
    [string]$ProjectName = "library_site",   # имя Django-проекта
    [string]$AppName = "main"                # имя приложения
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

# Переход в директорию, если скрипт вызван извне
if ($PWD.Path -notlike "*$ProjectName") {
    Write-Host "📂 Переход в подкаталог '$ProjectName'..."
    New-Item -ItemType Directory -Path $ProjectName -Force | Out-Null
    Set-Location $ProjectName
}

# Проверка manage.py
if (Test-Path "manage.py") {
    Write-Host "✅ Django-проект уже существует — пропускаю создание"
} else {
    # 1. Виртуальное окружение
    if (Test-Path ".\venv\Scripts\Activate.ps1") {
        Write-Host "✅ Виртуальное окружение уже есть"
    } else {
        Write-Host "📦 Создаю виртуальное окружение..."
        python -m venv venv
    }

    Write-Host "🔁 Активирую виртуальное окружение..."
    & ".\venv\Scripts\Activate.ps1"

    # 2. Установка Django
    $p = pip show django
    if (-not $p) {
        Write-Host "⬇ Устанавливаю Django..."
        pip install django
    } else {
        Write-Host "✅ Django уже установлен"
    }

    # 3. Создание проекта (только если manage.py ещё не существует)
    Write-Host "🛠️ Инициализирую Django-проект '$ProjectName'..."
    django-admin startproject $ProjectName .
}

# 4. Приложение
if (Test-Path "$AppName\apps.py") {
    Write-Host "✅ Приложение '$AppName' уже существует"
} else {
    Write-Host "📂 Создаю приложение '$AppName'..."
    python manage.py startapp $AppName
}

# 5. Папки шаблонов и статики
New-Item -ItemType Directory -Path "$AppName\templates\$AppName" -Force | Out-Null
New-Item -ItemType Directory -Path "$AppName\static\$AppName" -Force | Out-Null

Write-Host "`n✅ Готово. Проект можно использовать многократно, без дублирования."
