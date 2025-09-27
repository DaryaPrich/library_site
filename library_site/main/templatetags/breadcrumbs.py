from django import template
from django.urls import Resolver404, resolve

register = template.Library()

# Словарь локализации
BREADCRUMB_TITLES = {
    "index": "Главная",
    "books_list": "Каталог",
    "book_detail": "Книга",
    "account": "Личный кабинет",
    "users_list": "Пользователи",
    "about": "О нас",
    "contact": "Контакты",
    "login": "Вход",
    "register": "Регистрация",
}


@register.inclusion_tag("main/breadcrumbs.html", takes_context=True)
def breadcrumbs(context):
    request = context["request"]
    path = request.path.strip("/").split("/")
    crumbs = []
    url = "/"

    for i, part in enumerate(path):
        url += part + "/"
        try:
            match = resolve(url)
            # получаем name из urls.py
            name = match.url_name or part
        except Resolver404:
            name = part

        # локализация через словарь
        display_name = BREADCRUMB_TITLES.get(name, name.capitalize())

        crumbs.append({
            "name": display_name,
            "url": url if i < len(path) - 1 else None,  # последняя крошка без ссылки
        })

    return {"crumbs": crumbs}
