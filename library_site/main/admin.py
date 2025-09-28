from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from .models import Book, Booking, CustomUser, Genre, LiteratureType, Message

admin.site.register(Book)
admin.site.register(Booking)
admin.site.register(Message)
admin.site.register(LiteratureType)
admin.site.register(Genre)
admin.site.register(CustomUser, UserAdmin)
