from django.contrib import admin
from .models import Book, Category, Booking, Message, CustomUser
from django.contrib.auth.admin import UserAdmin

admin.site.register(Book)
admin.site.register(Category)
admin.site.register(Booking)
admin.site.register(Message)
admin.site.register(CustomUser, UserAdmin)
