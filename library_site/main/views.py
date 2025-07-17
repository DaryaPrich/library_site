from django.shortcuts import render, get_object_or_404
from .models import Book

def index(request):
    return render(request, 'main/index.html')

def books_list(request):
    books = Book.objects.all()
    return render(request, 'main/books_list.html', {'books': books})

def book_detail(request, book_id):
    book = get_object_or_404(Book, pk=book_id)
    return render(request, 'main/book_detail.html', {'book': book})

def account(request):
    return render(request, 'main/account.html')

def about(request):
    return render(request, 'main/about.html')

def contact(request):
    return render(request, 'main/contact.html')

def login_view(request):
    return render(request, 'main/login.html')

def register_view(request):
    return render(request, 'main/register.html')
from django.contrib.auth import login, authenticate, logout
from django.shortcuts import render, redirect
from .forms import RegisterForm
from django.contrib.auth.decorators import login_required

def register_view(request):
    if request.method == 'POST':
        form = RegisterForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect('account')
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
def account_view(request):
    user = request.user
    books = user.booking_set.all()
    return render(request, 'main/account.html', {'user': user, 'books': books})
