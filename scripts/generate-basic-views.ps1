[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$AppName = "main"
$ProjectDir = "library_site"
$TemplatePath = "$AppName\templates\$AppName"

# 0. Проверка активации виртуального окружения
if (-not (Test-Path ".\venv\Scripts\Activate.ps1")) {
    Write-Host "❌ Виртуальное окружение 'venv' не найдено!" -ForegroundColor Red
    exit
}

Write-Host "🌀 Активирую виртуальное окружение..."
& ".\venv\Scripts\Activate.ps1"

# 0.1 Проверка установки Django
$p = pip show django
if (-not $p) {
    Write-Host "📦 Устанавливаю Django..."
    pip install django
} else {
    Write-Host "✅ Django уже установлен"
}

# 1. views.py
Write-Host "🧠 Создаю views.py..."
@"
from django.shortcuts import render, get_object_or_404
from .models import Book

def index(request):
    return render(request, '$AppName/index.html')

def books_list(request):
    books = Book.objects.all()
    return render(request, '$AppName/books_list.html', {'books': books})

def book_detail(request, book_id):
    book = get_object_or_404(Book, pk=book_id)
    return render(request, '$AppName/book_detail.html', {'book': book})

def account(request):
    return render(request, '$AppName/account.html')

def about(request):
    return render(request, '$AppName/about.html')

def contact(request):
    return render(request, '$AppName/contact.html')

def login_view(request):
    return render(request, '$AppName/login.html')

def register_view(request):
    return render(request, '$AppName/register.html')
"@ | Set-Content -Encoding UTF8 "$AppName\views.py"

# 2. urls.py (внутри приложения)
Write-Host "🔗 Создаю main/urls.py..."
@"
from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('books/', views.books_list, name='books_list'),
    path('books/<int:book_id>/', views.book_detail, name='book_detail'),
    path('account/', views.account, name='account'),
    path('about/', views.about, name='about'),
    path('contact/', views.contact, name='contact'),
    path('login/', views.login_view, name='login'),
    path('register/', views.register_view, name='register'),
]
"@ | Set-Content -Encoding UTF8 "$AppName\urls.py"

# 3. Подключение в project urls.py
$urlsFile = "$ProjectDir\urls.py"
$urlsContent = Get-Content $urlsFile -Raw

# Добавим include при необходимости
if ($urlsContent -notmatch "include") {
    $urlsContent = $urlsContent -replace "(from django.urls import path)", "from django.urls import path, include"
    Write-Host "➕ Добавлен импорт include"
}

# Добавим подключение маршрутов приложения
if ($urlsContent -notmatch "$AppName\.urls") {
    $urlsContent = $urlsContent -replace "(urlpatterns\s*=\s*\[)", "`$1`n    path('', include('$AppName.urls')),"
    Write-Host "✅ Подключен '$AppName.urls' в $urlsFile"
}

Set-Content $urlsFile $urlsContent

# 4. Создание base.html
$baseFile = "$TemplatePath\base.html"
Write-Host "🎨 Создаю base.html..."
@"
<!DOCTYPE html>
<html lang='ru'>
<head>
    <meta charset='UTF-8'>
    <title>{% block title %}Библиотека{% endblock %}</title>
</head>
<body>
    <nav>
        <a href="/">Главная</a> |
        <a href="/books/">Каталог</a> |
        <a href="/account/">Кабинет</a> |
        <a href="/about/">О нас</a> |
        <a href="/contact/">Контакты</a>
    </nav>
    <hr>
    <div>
        {% block content %}
        {% endblock %}
    </div>
</body>
</html>
"@ | Set-Content -Encoding UTF8 $baseFile

# 5. Обновление всех шаблонов
$templateFiles = @(
    "index.html",
    "books_list.html",
    "book_detail.html",
    "account.html",
    "login.html",
    "register.html",
    "about.html",
    "contact.html"
)
foreach ($file in $templateFiles) {
    Set-Content -Encoding UTF8 "$TemplatePath\$file" @"
{% extends '$AppName/base.html' %}
{% block title %}Страница: $file{% endblock %}
{% block content %}
<h1>$file</h1>
{% endblock %}
"@
}

Write-Host "`n✅ Всё готово! Представления, маршруты и шаблоны настроены." -ForegroundColor Green
Write-Host "➡ Запускай сервер: python manage.py runserver"
Write-Host "➡ И открой: http://127.0.0.1:8000/"
