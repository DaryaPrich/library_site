# main/urls.py
from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),

    # Книги
    path("books/", views.books_list, name="books_list"),
    path("books/add/", views.add_book, name="add_book"),
    path("books/<int:book_id>/", views.book_detail, name="book_detail"),
    path("books/<int:book_id>/edit/", views.edit_book, name="edit_book"),
    path("books/<int:book_id>/delete/", views.delete_book, name="delete_book"),
    path("books/<int:pk>/read/", views.read_book, name="read_book"),

    # Страницы
    path("account/", views.account_view, name="account"),
    path("about/", views.about, name="about"),
    path("contact/", views.contact, name="contact"),

    # Аутентификация
    path("login/", views.login_view, name="login"),
    path("register/", views.register_view, name="register"),
    path("logout/", views.logout_view, name="logout"),

    # 🔹 Управление пользователями (для админов)
    path("users/", views.UserListView.as_view(), name="users_list"),
    path("users/create/", views.UserCreateView.as_view(), name="users_create"),
    path("users/<int:pk>/edit/", views.UserUpdateView.as_view(), name="users_edit"),
    path("users/<int:pk>/delete/", views.UserDeleteView.as_view(), name="users_delete"),

    path('cabinet/', views.cabinet, name='cabinet'),
    path('cabinet_guest/', views.cabinet_guest, name='cabinet_guest'),

    # Типы литературы
    path("literature-types/", views.LiteratureTypeListView.as_view(), name="literaturetype_list"),
    path("literature-types/add/", views.LiteratureTypeCreateView.as_view(), name="literaturetype_add"),
    path("literature-types/<int:pk>/edit/", views.LiteratureTypeUpdateView.as_view(), name="literaturetype_edit"),
    path("literature-types/<int:pk>/delete/", views.LiteratureTypeDeleteView.as_view(), name="literaturetype_delete"),

    # Жанры
    path("genres/", views.GenreListView.as_view(), name="genre_list"),
    path("genres/add/", views.GenreCreateView.as_view(), name="genre_add"),
    path("genres/<int:pk>/edit/", views.GenreUpdateView.as_view(), name="genre_edit"),
    path("genres/<int:pk>/delete/", views.GenreDeleteView.as_view(), name="genre_delete"),

    path("privacy/", views.PrivacyPolicyView.as_view(), name="privacy_policy"),
    path("new-books/", views.new_books, name="new_books"),
    path("news/", views.NewsListView.as_view(), name="news_list"),
    path("news/<int:pk>/", views.NewsDetailView.as_view(), name="news_detail"),

    path("genres/<int:pk>/books/", views.GenreBooksView.as_view(), name="genre_books"),

]
