from django.contrib.auth import login
from django.contrib.auth import logout

from .forms import RegisterForm
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.shortcuts import get_object_or_404, redirect
from .models import Book

from django.contrib.auth.decorators import login_required
from django.shortcuts import render
from .models import Booking


def index(request):
    return render(request, 'main/index.html')


def books_list(request):
    books = Book.objects.all()

    book_ids_taken = set()
    if request.user.is_authenticated:
        book_ids_taken = set(
            Booking.objects.filter(user=request.user, status='pending')
            .values_list('book_id', flat=True)
        )

    return render(request, 'main/books_list.html', {
        'books': books,
        'book_ids_taken': book_ids_taken,
    })


@login_required
def book_detail(request, book_id):
    book = get_object_or_404(Book, id=book_id)

    # Проверяем, есть ли уже активное бронирование этой книги у пользователя
    existing = Booking.objects.filter(user=request.user, book=book, status='pending').first()

    if request.method == 'POST':
        if book.copies_available > 0:
            if not existing:
                # Создаём бронирование
                Booking.objects.create(user=request.user, book=book)
                book.copies_available -= 1
                book.save()
                messages.success(request, f'Вы успешно взяли книгу: {book.title}')
            else:
                messages.info(request, 'Вы уже взяли эту книгу ранее.')
        else:
            messages.error(request, 'Книга недоступна для бронирования.')

        return redirect('account')

    return render(request, 'main/book_detail.html', {
        'book': book,
        'already_taken': bool(existing)
    })


def account(request):
    return render(request, 'main/account.html')


def about(request):
    return render(request, 'main/about.html')


def contact(request):
    return render(request, 'main/contact.html')


def login_view(request):
    return render(request, 'main/login.html')


def register_view(request):
    if request.method == 'POST':
        form = RegisterForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)  # Авторизуем нового пользователя
            return redirect('account')  # Переход в личный кабинет
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
def book_detail_view(request, pk):
    book = get_object_or_404(Book, pk=pk)

    if request.method == 'POST':
        if book.copies_available > 0:
            Booking.objects.create(user=request.user, book=book)
            book.copies_available -= 1
            book.save()
        return redirect('account')  # или 'book_detail', args=[pk]

    return render(request, 'main/book_detail.html', {'book': book})


@login_required
def account_view(request):
    user = request.user
    # Явный вывод бронирований
    bookings = Booking.objects.filter(user=user, status='pending')
    print(f"📚 Найдено бронирований: {bookings.count()}")
    for b in bookings:
        print(f"- {b.book.title} ({b.status})")

    return render(request, 'main/account.html', {
        'user': user,
        'bookings': bookings,
    })


@login_required
def return_book(request, booking_id):
    booking = get_object_or_404(Booking, id=booking_id, user=request.user, status='pending')

    if request.method == 'POST':
        booking.status = 'returned'
        booking.save()
        booking.book.copies_available += 1
        booking.book.save()
        messages.success(request, f'Книга «{booking.book.title}» успешно возвращена.')

    return redirect('account')
