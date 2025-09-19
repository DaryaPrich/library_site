import argparse
import os
import pathlib
import sqlite3
import subprocess
import sys

BASE_DIR = pathlib.Path(__file__).resolve().parent
DB_PATH = BASE_DIR / "db.sqlite3"
SQL_PATH = BASE_DIR / "seed-data.sql"


def pre_cleanup():
    if not DB_PATH.exists():
        return
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    tables = {r[0] for r in cur.execute(
        "SELECT name FROM sqlite_master WHERE type='table'").fetchall()}

    def safe_exec(sql):
        try:
            cur.execute(sql)
        except sqlite3.OperationalError:
            pass

    if "auth_group_permissions" in tables:
        safe_exec("DELETE FROM auth_group_permissions;")
    if "auth_permission" in tables:
        safe_exec("DELETE FROM auth_permission;")
    if "django_content_type" in tables:
        safe_exec("DELETE FROM django_content_type;")
    conn.commit()
    conn.close()


def run_migrate():
    print("=== Применяем миграции ===")
    res = subprocess.run([sys.executable, "manage.py", "migrate"], cwd=BASE_DIR)
    if res.returncode != 0:
        raise RuntimeError("Ошибка при выполнении миграций")


def rebuild_permissions():
    """Гарантированно создаём permissions для всех моделей (на случай, если сигнал не сработал)."""
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "library_site.settings")
    import django
    django.setup()
    from django.apps import apps
    from django.contrib.auth.management import create_permissions
    from django.contrib.auth.models import Permission

    for app_config in apps.get_app_configs():
        create_permissions(app_config, verbosity=0)
    print(f"Права пересозданы. Всего прав в БД: {Permission.objects.count()}")


def run_seed_sql():
    print("=== Очистка и заполнение БД из seed-data.sql ===")
    if not SQL_PATH.exists():
        raise FileNotFoundError(f"Не найден {SQL_PATH}")
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    with open(SQL_PATH, "r", encoding="utf-8") as f:
        cur.executescript(f.read())
    conn.commit()
    conn.close()


def assign_group_perms():
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "library_site.settings")
    import django
    django.setup()
    from django.contrib.auth.models import Group, Permission
    from django.contrib.contenttypes.models import ContentType
    from main.models import Book

    ct_book = ContentType.objects.get_for_model(Book)
    scheme = {
        "Администраторы": ["add_book", "change_book", "delete_book", "view_book"],  # CRUD
        "Библиотекари": ["add_book", "change_book", "view_book"],  # CRU
        "Читатели": ["view_book"],  # R
    }
    for group_name, codes in scheme.items():
        try:
            grp = Group.objects.get(name=group_name)
        except Group.DoesNotExist:
            print(f"Внимание: нет группы '{group_name}', пропускаю.")
            continue
        perms = Permission.objects.filter(content_type=ct_book, codename__in=codes)
        grp.permissions.set(perms)
        print(f"Назначены права группе '{group_name}': {', '.join(codes)}")


def reset_passwords():
    """Принудительно ставим всем тест-пользователям пароль '123456' через Django hasher."""
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "library_site.settings")
    import django
    django.setup()
    from django.contrib.auth import get_user_model
    User = get_user_model()

    for username in ["admin", "librarian1", "reader1"]:
        try:
            u = User.objects.get(username=username)
        except User.DoesNotExist:
            print(f"Пользователь '{username}' не найден — пропускаю.")
            continue
        u.set_password("123456")
        u.is_active = True
        u.save(update_fields=["password", "is_active"])
        print(f"Пароль обновлён для {username}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--fresh", action="store_true", help="Удалить db.sqlite3 перед миграциями.")
    args = ap.parse_args()

    if args.fresh and DB_PATH.exists():
        DB_PATH.unlink()
        print("Удалён файл базы данных (fresh).")

    pre_cleanup()
    run_migrate()
    rebuild_permissions()  # <--- ДОБАВИЛИ ЭТО
    run_seed_sql()
    assign_group_perms()
    reset_passwords()
    print("Готово! Вход: admin / librarian1 / reader1 (пароль у всех: 123456).")


if __name__ == "__main__":
    main()
