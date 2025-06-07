from django.urls import path
from django.contrib.auth import views as auth_views

from . import views

urlpatterns = [
    path('return/<int:booking_id>/', views.return_book, name='return_book'),
    path('', views.index, name='index'),
    path('books/', views.books_list, name='books_list'),
    path('books/<int:book_id>/', views.book_detail, name='book_detail'),
    path('account/', views.account_view, name='account'),
    path('about/', views.about, name='aboыut'),
    path('contact/', views.contact, name='contact'),
    path('login/', views.login_view, name='login'),
    path('register/', views.register_view, name='register'),
    path('books/<int:pk>/', views.book_detail_view, name='book_detail'),
    path('logout/', auth_views.LogoutView.as_view(next_page='/'), name='logout')
]
