[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

$formsPath = "main\forms.py"
$viewsPath = "main\views.py"
$urlsPath = "main\auth_urls.py"
$templateDir = "main\templates\main"

# 1. Создание формы регистрации
Set-Content $formsPath @"
from django import forms
from django.contrib.auth.forms import UserCreationForm
from .models import CustomUser

class RegisterForm(UserCreationForm):
    class Meta:
        model = CustomUser
        fields = ['username', 'email', 'password1', 'password2']
"@
Write-Host "✅ Создан: $formsPath"

# 2. Добавление views (расширение файла)
Add-Content $viewsPath @"
from django.contrib.auth import login, authenticate, logout
from django.shortcuts import render, redirect
from .forms import RegisterForm
from django.contrib.auth.decorators import login_required

def register_view(request):
    if request.method == 'POST':
        form = RegisterForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect('account')
    else:
        form = RegisterForm()
    return render(request, 'main/register.html', {'form': form})

def login_view(request):
    from django.contrib.auth.forms import AuthenticationForm
    if request.method == 'POST':
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            return redirect('account')
    else:
        form = AuthenticationForm()
    return render(request, 'main/login.html', {'form': form})

def logout_view(request):
    logout(request)
    return redirect('index')

@login_required
def account_view(request):
    user = request.user
    books = user.booking_set.all()
    return render(request, 'main/account.html', {'user': user, 'books': books})
"@
Write-Host "✅ Обновлён: $viewsPath"

# 3. Создание auth_urls.py
Set-Content $urlsPath @"
from django.urls import path
from . import views

urlpatterns = [
    path('register/', views.register_view, name='register'),
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('account/', views.account_view, name='account'),
]
"@
Write-Host "✅ Создан: $urlsPath"

# 4. Добавление шаблонов
$templates = @{
    "login.html" = @"
{% extends 'main/base.html' %}
{% block content %}
<h2>Вход</h2>
<form method="post">{% csrf_token %}
{{ form.as_p }}
<button type="submit">Войти</button>
</form>
{% endblock %}
"@;

    "register.html" = @"
{% extends 'main/base.html' %}
{% block content %}
<h2>Регистрация</h2>
<form method="post">{% csrf_token %}
{{ form.as_p }}
<button type="submit">Зарегистрироваться</button>
</form>
{% endblock %}
"@;

    "account.html" = @"
{% extends 'main/base.html' %}
{% block content %}
<h2>Личный кабинет</h2>
<p>Привет, {{ user.username }}!</p>
<h3>Взятые книги:</h3>
<ul>
{% for book in books %}
  <li>{{ book.title }}</li>
{% empty %}
  <li>Вы пока не брали книги.</li>
{% endfor %}
</ul>
{% endblock %}
"@
}

foreach ($file in $templates.Keys) {
    $path = Join-Path $templateDir $file
    $dir = Split-Path $path
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    Set-Content $path $templates[$file]
    Write-Host "📝 Шаблон: $file создан"
}

Write-Host "`n✅ Авторизация, регистрация и личный кабинет готовы!" -ForegroundColor Cyan
