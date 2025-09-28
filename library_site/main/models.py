from django.conf import settings
from django.contrib.auth.models import AbstractUser
from django.db import models


class LiteratureType(models.Model):
    name = models.CharField(max_length=100, verbose_name="Тип литературы")

    def __str__(self):
        return self.name


class Genre(models.Model):
    name = models.CharField(max_length=100, verbose_name="Жанр")

    def __str__(self):
        return self.name


class Book(models.Model):
    title = models.CharField(max_length=200)
    author = models.CharField(max_length=200)
    isbn = models.CharField(max_length=20, blank=True, null=True)
    year = models.PositiveIntegerField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    cover_image = models.URLField(blank=True, null=True)

    literature_type = models.ForeignKey("LiteratureType", on_delete=models.SET_NULL, null=True, blank=True)
    genres = models.ManyToManyField("Genre", blank=True, related_name="books")

    # новые поля
    udc = models.CharField("УДК", max_length=50, blank=True, null=True)
    bbc = models.CharField("ББК", max_length=50, blank=True, null=True)
    marc = models.CharField("MARC", max_length=100, blank=True, null=True)

    file_url = models.URLField(blank=True, null=True)
    file = models.FileField(upload_to="books/", blank=True, null=True)

    def get_access_url(self):
        if self.file_url:
            return self.file_url
        if self.file:
            return self.file.url
        return ""

    def __str__(self):
        return f"{self.title} — {self.author}"


class CustomUser(AbstractUser):
    ROLE_CHOICES = [
        ('reader', 'Читатель'),
        ('librarian', 'Библиотекарь'),
        ('admin', 'Администратор'),
    ]
    role = models.CharField(
        max_length=10,
        choices=ROLE_CHOICES,
        default='reader',
        verbose_name='Роль'
    )


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
        unique_together = ('user', 'book')
