from django.conf import settings
from django.contrib.auth.models import AbstractUser
from django.db import models


class Category(models.Model):
    name = models.CharField(max_length=100, verbose_name='Название категории')

    def __str__(self):
        return self.name


class Book(models.Model):
    title = models.CharField(max_length=255, verbose_name='Название')
    author = models.CharField(max_length=255, verbose_name='Автор')
    isbn = models.CharField(max_length=20, unique=True, verbose_name='ISBN')
    year = models.PositiveIntegerField(verbose_name='Год издания')
    description = models.TextField(blank=True, verbose_name='Описание')
    cover_image = models.ImageField(upload_to='covers/', null=True, blank=True, verbose_name='Обложка')
    copies_total = models.PositiveIntegerField(default=1, verbose_name='Всего экземпляров')
    copies_available = models.PositiveIntegerField(default=1, verbose_name='Доступно экземпляров')
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True, verbose_name='Категория')
    file_url = models.URLField('Ссылка на книгу', blank=True, null=True)
    file = models.FileField('Файл книги', upload_to='books/', blank=True, null=True)

    # models.py
    def get_access_url(self):
        if self.file_url:
            return self.file_url
        if self.file:
            return self.file.url
        return ''

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


class ReadHistory(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    book = models.ForeignKey('Book', on_delete=models.CASCADE)
    read_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('user', 'book')  # один раз достаточно
