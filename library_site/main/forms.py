from django import forms
from django.contrib.auth import get_user_model
from django.contrib.auth.forms import UserCreationForm

from .models import Book
from .models import CustomUser


class RegisterForm(UserCreationForm):
    class Meta:
        model = CustomUser
        fields = ['username', 'email', 'password1', 'password2']


class BookForm(forms.ModelForm):
    class Meta:
        model = Book
        fields = '__all__'


# main/forms.py
from django import forms
from .models import Book  # если уже есть — не дублируй


class BookForm(forms.ModelForm):
    class Meta:
        model = Book
        fields = [
            "title", "author", "isbn", "year", "description",
            # "copies_total", "copies_available", 
            "category",
            "cover_image",  # <— новое поле (URL обложки)
            "file_url",  # <— ссылка на книгу
            "file",  # <— файл книги
        ]
        widgets = {
            "title": forms.TextInput(attrs={"class": "form-control"}),
            "author": forms.TextInput(attrs={"class": "form-control"}),
            "isbn": forms.TextInput(attrs={"class": "form-control"}),
            "year": forms.NumberInput(attrs={"class": "form-control"}),
            "description": forms.Textarea(attrs={"class": "form-control", "rows": 7}),
            "copies_total": forms.NumberInput(attrs={"class": "form-control"}),
            "copies_available": forms.NumberInput(attrs={"class": "form-control"}),
            "category": forms.Select(attrs={"class": "form-select"}),
            "cover_image": forms.URLInput(attrs={"class": "form-control", "placeholder": "https://..."}),
            "file_url": forms.URLInput(attrs={"class": "form-control", "placeholder": "https://..."}),
            "file": forms.ClearableFileInput(attrs={"class": "form-control"}),
        }
        help_texts = {
            "file": "При наличии файла он используется в приоритете над ссылкой.",
        }


User = get_user_model()


class UserForm(forms.ModelForm):
    password = forms.CharField(
        label="Пароль",
        widget=forms.PasswordInput(attrs={"class": "form-control"}),
        required=False,
        help_text="Оставьте пустым, если не нужно менять пароль."
    )

    class Meta:
        model = User
        # ЯВНО перечисляем поля, user_permissions здесь НЕТ
        fields = [
            "username", "email", "first_name", "last_name",
            "is_active", "is_staff", "is_superuser",
            "groups", "password",
            # "role",  # ← добавляем роль
        ]
        widgets = {
            "username": forms.TextInput(attrs={"class": "form-control"}),
            "email": forms.EmailInput(attrs={"class": "form-control"}),
            "first_name": forms.TextInput(attrs={"class": "form-control"}),
            "last_name": forms.TextInput(attrs={"class": "form-control"}),
            "is_active": forms.CheckboxInput(attrs={"class": "form-check-input"}),
            "is_staff": forms.CheckboxInput(attrs={"class": "form-check-input"}),
            "is_superuser": forms.CheckboxInput(attrs={"class": "form-check-input"}),
            "groups": forms.SelectMultiple(attrs={"class": "form-control", "size": 8}),
        }

    class Meta:
        model = User
        fields = [
            "username", "email", "first_name", "last_name",
            "is_active", "is_staff", "is_superuser",
            "groups", "user_permissions", "password",
        ]

    def save(self, commit=True):
        user = super().save(commit=False)
        pwd = self.cleaned_data.get("password")
        if pwd:
            user.set_password(pwd)
        if commit:
            user.save()
            self.save_m2m()
        return user
