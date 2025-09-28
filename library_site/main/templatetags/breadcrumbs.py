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
    "users_edit": "Редактирование пользователя",
    "user_update": "Редактирование пользователя",
    "users_create": "Создание пользователя",
    "user_create": "Создание пользователя",
    "users_delete": "Удаление пользователя",
    "user_delete": "Удаление пользователя",
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
            name = match.url_name or part
        except Resolver404:
            name = part

        # 1. Если сегмент — число (id), выводим как "Пользователь 6"
        if part.isdigit():
            display_name = f"Пользователь {part}"
            crumb_url = None  # ← без ссылки
        else:
            display_name = BREADCRUMB_TITLES.get(name, name.capitalize())
            crumb_url = url if i < len(path) - 1 else None

        crumbs.append({"name": display_name, "url": crumb_url})

    return {"crumbs": crumbs}
