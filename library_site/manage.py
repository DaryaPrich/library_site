#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys


def main():
    """Run administrative tasks."""
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'library_site.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc
    execute_from_command_line(sys.argv)


# !/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys


def main():
    """Run administrative tasks."""
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'library_site.settings')
    from django.core.management import execute_from_command_line
    execute_from_command_line(sys.argv)


# !/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys

if __name__ == '__main__':
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'library_site.settings')

    # Инициализация Django
    import django

    django.setup()

    # Генерация хеша с фиксированной солью
    from django.contrib.auth.hashers import PBKDF2PasswordHasher

    hasher = PBKDF2PasswordHasher()
    password = '123456'
    salt = 'static_salt_123'
    iterations = 600000

    hashed = hasher.encode(password=password, salt=salt, iterations=iterations)

    print("\n=== Генерация хеша для пароля '123456' ===")
    print(hashed)
    print("===========================================\n")

    # Запуск стандартного Django CLI
    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
