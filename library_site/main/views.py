from django.conf import settings
from django.contrib import messages
from django.contrib.auth import login
from django.contrib.auth import logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import AuthenticationForm
from django.contrib.auth.hashers import check_password, make_password
from django.shortcuts import get_object_or_404

from .forms import BookForm  # если формы нет — создадим ниже
from .forms import RegisterForm
from .models import CustomUser


def index(request):
    return render(request, 'main/index.html')


from .models import Book, ReadHistory


def _chunked(seq, size):
    """Разбивает список на подсписки по size элементов (для слайдов карусели)."""
    return [seq[i:i + size] for i in range(0, len(seq), size)]


def books_list(request):
    # все книги для каталога
    books = Book.objects.all()

    # === Подборка для карусели ===
    carousel_title = "Популярное"
    qs = Book.objects.exclude(cover_image__isnull=True).exclude(cover_image="")

    if request.user.is_authenticated:
        # ID всех прочитанных пользователем книг
        read_ids = list(
            ReadHistory.objects.filter(user=request.user)
            .order_by("-read_at")
            .values_list("book_id", flat=True)
        )
        if read_ids:
            # категории этих книг
            cats = list(Book.objects.filter(id__in=read_ids).values_list("category_id", flat=True))
            # рекомендации из этих категорий (не включая уже прочитанные)
            rec = qs.filter(category_id__in=cats).exclude(id__in=read_ids)[:18]
            if rec:
                carousel_title = "Рекомендовано вам"
                carousel_books = list(rec)
            else:
                carousel_books = list(qs.order_by("-copies_total")[:18])
        else:
            carousel_books = list(qs.order_by("-copies_total")[:18])
    else:
        carousel_books = list(qs.order_by("-copies_total")[:18])

    # режем на слайды по 6 обложек
    carousel_slides = _chunked(carousel_books, 6)

    context = {
        "books": books,
        "carousel_title": carousel_title,
        "carousel_slides": carousel_slides,
    }
    return render(request, "main/books_list.html", context)


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
    if request.method == 'POST':
        form = AuthenticationForm(request, data=request.POST)

        if settings.DEBUG:
            username = request.POST.get('username')
            password = request.POST.get('password')

            print("=== DEBUG: логин ===")
            print("Введён логин:", username)
            print("Введён пароль:", password)
            print("Сгенерированный хеш (один из вариантов):", make_password(password))

            try:
                user_in_db = CustomUser.objects.get(username=username)
                print("Хеш в базе:", user_in_db.password)
                is_match = check_password(password, user_in_db.password)
                print("Совпадает ли пароль:", is_match)
            except CustomUser.DoesNotExist:
                print("Пользователь не найден")

        if form.is_valid():
            user = form.get_user()
            login(request, user)
            return redirect('account')
    else:
        form = AuthenticationForm()
    return render(request, 'main/login.html', {'form': form})


def logout_view(request):
    logout(request)
    return redirect('login')


@login_required
def account_view(request):
    read_books = ReadHistory.objects.filter(user=request.user).select_related('book').order_by('-read_at')
    return render(request, 'main/account.html', {
        'user': request.user,
        'read_books': read_books
    })


@login_required
def books_list_view(request):
    books = Book.objects.all()
    return render(request, 'main/books_list.html', {'books': books})


@login_required
def read_book(request, pk):
    book = get_object_or_404(Book, pk=pk)
    # записываем в историю
    ReadHistory.objects.get_or_create(user=request.user, book=book)
    # редиректим на файл или ссылку
    url = book.get_access_url()
    if url:
        return redirect(url)
    messages.error(request, 'У этой книги нет файла или ссылки.')
    return redirect('book_detail', book_id=pk)


# views.py
@login_required
def add_book(request):
    if request.user.role not in ['admin', 'librarian']:
        return redirect('books_list')

    if request.method == 'POST':
        form = BookForm(request.POST, request.FILES)  # <-- добавили request.FILES
        if form.is_valid():
            form.save()
            return redirect('books_list')
    else:
        form = BookForm()
    return render(request, 'main/book_form.html', {'form': form})


@login_required
def edit_book(request, book_id):
    if request.user.role not in ['admin', 'librarian']:
        return redirect('books_list')

    book = get_object_or_404(Book, id=book_id)
    if request.method == 'POST':
        form = BookForm(request.POST, request.FILES, instance=book)  # <-- тоже с FILES
        if form.is_valid():
            form.save()
            return redirect('books_list')
    else:
        form = BookForm(instance=book)
    return render(request, 'main/edit_book.html', {'form': form, 'book': book})


@login_required
def delete_book(request, book_id):
    if request.user.role != 'admin':
        return redirect('books_list')  # Только админ может удалять

    book = get_object_or_404(Book, id=book_id)
    book.delete()
    return redirect('books_list')


from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required


def cabinet_guest(request):
    return render(request, 'main/login_required.html')


@login_required(login_url='/cabinet_guest/')
def cabinet(request):
    # твоя логика личного кабинета
    return render(request, 'main/cabinet.html')


from django.contrib.auth import get_user_model
from django.contrib.auth.mixins import UserPassesTestMixin, LoginRequiredMixin
from django.urls import reverse_lazy
from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from django.db.models import Q
from .forms import UserForm

User = get_user_model()


class StaffOnlyMixin(UserPassesTestMixin):
    def test_func(self):
        return self.request.user.is_authenticated and self.request.user.is_staff

    def handle_no_permission(self):
        from django.http import HttpResponseForbidden
        return HttpResponseForbidden("Недостаточно прав.")


class UserListView(LoginRequiredMixin, StaffOnlyMixin, ListView):
    model = User
    template_name = "main/users_list.html"
    context_object_name = "users"
    paginate_by = 20

    def get_queryset(self):
        qs = super().get_queryset().order_by("id").prefetch_related("groups")
        q = self.request.GET.get("q")
        if q:
            qs = qs.filter(
                Q(username__icontains=q) |
                Q(email__icontains=q) |
                Q(first_name__icontains=q) |
                Q(last_name__icontains=q) |
                Q(groups__name__icontains=q)
            ).distinct()
        return qs


class UserCreateView(LoginRequiredMixin, StaffOnlyMixin, CreateView):
    model = User
    form_class = UserForm
    template_name = "main/user_form.html"
    success_url = reverse_lazy("users_list")

    def form_valid(self, form):
        response = super().form_valid(form)
        user = self.object
        if user.groups.filter(name="Администраторы").exists():
            user.role = "admin"
        elif user.groups.filter(name="Библиотекари").exists():
            user.role = "librarian"
        else:
            user.role = "reader"
        user.save()
        return response


class UserUpdateView(LoginRequiredMixin, StaffOnlyMixin, UpdateView):
    model = User
    form_class = UserForm
    template_name = "main/user_form.html"
    success_url = reverse_lazy("users_list")

    def form_valid(self, form):
        response = super().form_valid(form)
        user = self.object
        if user.groups.filter(name="Администраторы").exists():
            user.role = "admin"
        elif user.groups.filter(name="Библиотекари").exists():
            user.role = "librarian"
        else:
            user.role = "reader"
        user.save()
        return response


from django.http import HttpResponseForbidden


class UserDeleteView(LoginRequiredMixin, StaffOnlyMixin, DeleteView):
    model = User
    template_name = "main/user_confirm_delete.html"
    success_url = reverse_lazy("users_list")

    def post(self, request, *args, **kwargs):
        self.object = self.get_object()
        # запрет на удаление суперпользователя
        if self.object.is_superuser:
            return HttpResponseForbidden("Нельзя удалить суперпользователя.")
        # запрет на самоудаление
        if self.object.pk == request.user.pk:
            return HttpResponseForbidden("Нельзя удалить самого себя.")
        return super().post(request, *args, **kwargs)
