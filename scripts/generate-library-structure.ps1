[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$AppName = "main"
$ModelFile = "$AppName\models.py"
$AdminFile = "$AppName\admin.py"
$TemplatePath = "$AppName\templates\$AppName"
$SettingsFile = "library_site\settings.py"

# 0. Добавляем AUTH_USER_MODEL
$settingsText = Get-Content $SettingsFile -Raw
if ($settingsText -notmatch "AUTH_USER_MODEL") {
    Add-Content $SettingsFile "`nAUTH_USER_MODEL = 'main.CustomUser'"
    Write-Host "🔧 Добавлен AUTH_USER_MODEL в settings.py"
} else {
    Write-Host "✅ AUTH_USER_MODEL уже указан"
}

# 1. Удаление старой базы и миграций
if (Test-Path "db.sqlite3") {
    Remove-Item "db.sqlite3"
    Write-Host "🗑 Удалена старая база данных"
}
$MigrationPath = "$AppName\migrations"
if (Test-Path $MigrationPath) {
    Get-ChildItem $MigrationPath -Filter "*.py" | Where-Object { $_.Name -ne "__init__.py" } | Remove-Item
    Get-ChildItem $MigrationPath -Filter "*.pyc" | Remove-Item
    Write-Host "🧹 Удалены старые миграции"
}

# 2. Установка Pillow
Write-Host "📦 Проверка Pillow..."
$pillowCheck = pip show Pillow
if (-not $pillowCheck) {
    pip install Pillow
    Write-Host "✅ Установлен Pillow"
} else {
    Write-Host "✅ Pillow уже установлен"
}

# 3. Создание models.py
Write-Host "🧱 Перезаписываю models.py..."
@"
from django.db import models
from django.contrib.auth.models import AbstractUser

class Category(models.Model):
    name = models.CharField(max_length=100, verbose_name='Название категории')

    def __str__(self):
        return self.name

class Book(models.Model):
    title = models.CharField(max_length=255, verbose_name='Название')
    author = models.CharField(max_length=255, verbose_name='Автор')
    isbn = models.CharField(max_length=13, unique=True, verbose_name='ISBN')
    year = models.PositiveIntegerField(verbose_name='Год издания')
    description = models.TextField(blank=True, verbose_name='Описание')
    cover_image = models.ImageField(upload_to='covers/', null=True, blank=True, verbose_name='Обложка')
    copies_total = models.PositiveIntegerField(default=1, verbose_name='Всего экземпляров')
    copies_available = models.PositiveIntegerField(default=1, verbose_name='Доступно экземпляров')
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True, verbose_name='Категория')

    def __str__(self):
        return f"{self.title} — {self.author}"

class CustomUser(AbstractUser):
    ROLE_CHOICES = [
        ('reader', 'Читатель'),
        ('librarian', 'Библиотекарь'),
        ('admin', 'Администратор'),
    ]
    role = models.CharField(max_length=10, choices=ROLE_CHOICES, default='reader', verbose_name='Роль')

class Booking(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Ожидает'),
        ('approved', 'Подтверждена'),
        ('returned', 'Возвращена'),
    ]
    user = models.ForeignKey('CustomUser', on_delete=models.CASCADE)
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    booking_date = models.DateField(auto_now_add=True)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='pending')

class Message(models.Model):
    name = models.CharField(max_length=100)
    email = models.EmailField()
    message = models.TextField()
    date_sent = models.DateTimeField(auto_now_add=True)
"@ | Set-Content -Encoding UTF8 $ModelFile

# 4. admin.py
Write-Host "📚 Зарегистрирую модели в admin.py..."
@"
from django.contrib import admin
from .models import Book, Category, Booking, Message, CustomUser
from django.contrib.auth.admin import UserAdmin

admin.site.register(Book)
admin.site.register(Category)
admin.site.register(Booking)
admin.site.register(Message)
admin.site.register(CustomUser, UserAdmin)
"@ | Set-Content -Encoding UTF8 $AdminFile

# 5. Создание шаблонов
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
New-Item -ItemType Directory -Path $TemplatePath -Force | Out-Null
foreach ($file in $templateFiles) {
    Set-Content -Encoding UTF8 "$TemplatePath\$file" "<h1>$file</h1>"
}
Write-Host "🎨 Созданы шаблоны: $($templateFiles -join ', ')"

# 6. Миграции
Write-Host "⚙️ Выполняю миграции..."
python manage.py makemigrations
python manage.py migrate

Write-Host "`n✅ Всё готово! Модели, шаблоны и база данных обновлены."
