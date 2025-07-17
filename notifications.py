# notifications.py

from django.core.mail import send_mail
from django.contrib.auth import get_user_model
from .models import Book

def send_new_book_notifications():
    """
    Скрипт отправляет email всем пользователям,
    если добавлена новая книга по их интересам (категория).
    """
    User = get_user_model()
    users = User.objects.all()

    # Допустим, ты хранишь интересы в профиле (псевдополе interest)
    for user in users:
        # Здесь выбираем книги по интересам
        # Для примера: если пользователь интересуется 'Программированием'
        interested_books = Book.objects.filter(category__name__icontains=user.interest)

        if interested_books.exists():
            books_list = "\n".join([f"- {book.title} ({book.author})" for book in interested_books])

            send_mail(
                subject='Новые книги по вашим интересам',
                message=f'Здравствуйте, {user.username}!\n\n'
                        f'Мы добавили новые книги по вашей теме:\n\n'
                        f'{books_list}\n\n'
                        f'Хорошего чтения!',
                from_email='library@example.com',
                recipient_list=[user.email],
                fail_silently=False,
            )
