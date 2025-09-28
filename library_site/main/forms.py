from django.contrib.auth import get_user_model
from django.contrib.auth.forms import UserCreationForm

from .models import CustomUser


class RegisterForm(UserCreationForm):
    class Meta:
        model = CustomUser
        fields = ['username', 'email', 'password1', 'password2']


# main/forms.py
from django import forms
from .models import Book  # если уже есть — не дублируй


class BookForm(forms.ModelForm):
    class Meta:
        model = Book
        fields = [
            "title", "author", "isbn", "year", "description",
            "literature_type", "genres",
            "cover_image", "file_url", "file",
        ]
        widgets = {
            "title": forms.TextInput(attrs={"class": "form-control"}),
            "author": forms.TextInput(attrs={"class": "form-control"}),
            "isbn": forms.TextInput(attrs={"class": "form-control"}),
            "year": forms.NumberInput(attrs={"class": "form-control"}),
            "description": forms.Textarea(attrs={"class": "form-control", "rows": 7}),
            "copies_total": forms.NumberInput(attrs={"class": "form-control"}),
            "literature_type": forms.Select(attrs={"class": "form-select"}),
            "genres": forms.SelectMultiple(attrs={"class": "form-control", "size": 6}),
            "cover_image": forms.URLInput(attrs={"class": "form-control"}),
            "file_url": forms.URLInput(attrs={"class": "form-control"}),
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
