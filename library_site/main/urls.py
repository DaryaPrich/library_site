from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('books/', views.books_list, name='books_list'),
    path('books/<int:book_id>/', views.book_detail, name='book_detail'),
    path('account/', views.account_view, name='account'),
    path('books/<int:pk>/read/', views.read_book, name='read_book'),
    path('about/', views.about, name='about'),
    path('contact/', views.contact, name='contact'),
    path('login/', views.login_view, name='login'),
    path('register/', views.register_view, name='register'),
    path('logout/', views.logout_view, name='logout'),
    path('books/<int:book_id>/edit/', views.edit_book, name='edit_book'),
    path('books/<int:book_id>/delete/', views.delete_book, name='delete_book'),
    path('books/add/', views.add_book, name='add_book'),
    path('books/<int:pk>/read/', views.read_book, name='read_book'),
]
