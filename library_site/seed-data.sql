-- === ОЧИСТКА СИСТЕМНЫХ ТАБЛИЦ ===
--DELETE FROM auth_group_permissions;
--DELETE FROM auth_permission;
--DELETE FROM django_content_type;

-- === ОЧИСТКА ПРИЛОЖЕНИЯ ===
DELETE FROM main_booking;
DELETE FROM main_message;
DELETE FROM main_readhistory;
DELETE FROM main_book;
DELETE FROM main_category;
DELETE FROM main_customuser_groups;
DELETE FROM main_customuser_user_permissions;
DELETE FROM main_customuser;
DELETE FROM auth_group;

-- === СБРОС АВТОИНКРЕМЕНТА ===
DELETE FROM sqlite_sequence WHERE name IN (
    'main_category', 'main_book', 'main_customuser',
    'main_message', 'main_booking', 'main_readhistory',
    'auth_group'
);



-- === КАТЕГОРИИ ===
INSERT INTO main_category (id, name) VALUES
(1, 'Фантастика'),
(2, 'Наука'),
(3, 'История');

-- === КНИГИ ===
INSERT INTO main_book (
    id, title, author, isbn, year, description, cover_image,
    copies_total, copies_available, category_id
)
VALUES
-- Фантастика (category_id = 1)
(1, '1984', 'Джордж Оруэлл', '978-5-17-118366-1', 1949,
 'Антиутопия о тоталитарном обществе.',
 'https://www.storytel.com/images/1271788/cover/1984.jpg',
 5, 3, 1),

(4, 'Марсианин', 'Энди Вейер', '978-5-389-09706-7', 2011,
 'Инженер-ботаник выживает на Марсе.',
 'https://www.storytel.com/images/1919916/cover/martian.jpg',
 4, 4, 1),

(5, 'Дюна', 'Фрэнк Герберт', '978-5-17-083845-6', 1965,
 'Эпическая сага о пустынной планете.',
 'https://www.storytel.com/images/1643054/cover/dune.jpg',
 6, 5, 1),

(6, '451 градус по Фаренгейту', 'Рэй Брэдбери', '978-5-17-087107-1', 1953,
 'Общество, где книги под запретом.',
 'https://www.storytel.com/images/1234567/cover/fahrenheit-451.jpg',
 3, 2, 1),

(7, 'Автостопом по галактике', 'Дуглас Адамс', '978-5-389-09211-6', 1979,
 'Юмористическое путешествие по Вселенной.',
 'https://www.storytel.com/images/2345678/cover/hitchhikers-guide.jpg',
 2, 2, 1),

-- Наука (category_id = 2)
(2, 'Краткая история времени', 'Стивен Хокинг', '978-5-17-118367-8', 1988,
 'О природе времени и вселенной.',
 'https://www.storytel.com/images/3456789/cover/brief-history-of-time.jpg',
 3, 2, 2),

(8, 'Эгоистичный ген', 'Ричард Докинз', '978-5-17-057875-8', 1976,
 'О биологии и эволюции.',
 'https://www.storytel.com/images/4567890/cover/selfish-gene.jpg',
 2, 2, 2),

(9, 'Параллельные миры', 'Митио Каку', '978-5-389-05310-0', 2005,
 'Физика многомерных вселенных.',
 'https://www.storytel.com/images/5678901/cover/parallel-worlds.jpg',
 4, 4, 2),

(10, 'Структура научных революций', 'Томас Кун', '978-5-02-025451-3', 1962,
 'Парадигмы в науке.',
 'https://www.storytel.com/images/6789012/cover/structure-of-scientific-revolutions.jpg',
 3, 3, 2),

(11, 'Самая красивая история о науке', 'Юбер Рив', '978-5-699-27586-2', 2007,
 'Наука для всех.',
 'https://www.storytel.com/images/7890123/cover/beautiful-story-of-science.jpg',
 5, 5, 2),

-- История (category_id = 3)
(3, 'История России', 'Николай Карамзин', '978-5-17-118368-5', 1816,
 'Классический исторический труд.',
 'https://www.storytel.com/images/8901234/cover/history-of-russia.jpg',
 4, 4, 3),

(12, 'Государь', 'Никколо Макиавелли', '978-5-389-02029-4', 1532,
 'Политическая философия.',
 'https://www.storytel.com/images/9012345/cover/the-prince.jpg',
 3, 3, 3),

(13, 'История Европы', 'Норман Дэвис', '978-5-17-070816-1', 1996,
 'Обширный труд по европейской истории.',
 'https://www.storytel.com/images/9123456/cover/history-of-europe.jpg',
 2, 2, 3),

(14, 'Вторая мировая война', 'Уинстон Черчилль', '978-5-699-03474-3', 1948,
 'Мемуары и анализ событий.',
 'https://www.storytel.com/images/9234567/cover/second-world-war.jpg',
 3, 3, 3),

(15, 'История древнего мира', 'Иван Артамонов', '978-5-17-060343-5', 1954,
 'История античных цивилизаций.',
 'https://www.storytel.com/images/9345678/cover/ancient-world-history.jpg',
 4, 4, 3);

-- === ПОЛЬЗОВАТЕЛИ ===
-- Пароль у всех: 123456
INSERT INTO main_customuser (
    id, password, is_superuser, username, email, is_staff, is_active, date_joined,
    first_name, last_name, role
)
VALUES
(1, 'pbkdf2_sha256$720000$XAbYtW7g3cRf8FLYFz6LkN$uTz8cu+7F2YaRoHra30iLSC4+HlAo5eHuYmZSRx7McQ=',
 1, 'admin', 'admin@example.com', 1, 1, '2025-06-07 00:00:00',
 'Дарья', 'Причичик', 'admin'),

(2, 'pbkdf2_sha256$720000$XAbYtW7g3cRf8FLYFz6LkN$uTz8cu+7F2YaRoHra30iLSC4+HlAo5eHuYmZSRx7McQ=',
 0, 'librarian1', 'librarian1@example.com', 1, 1, '2025-06-07 00:00:00',
 'Иван', 'Библиотекарь', 'librarian'),

(3, 'pbkdf2_sha256$720000$XAbYtW7g3cRf8FLYFz6LkN$uTz8cu+7F2YaRoHra30iLSC4+HlAo5eHuYmZSRx7McQ=',
 0, 'reader1', 'reader1@example.com', 0, 1, '2025-06-07 00:00:00',
 'Анна', 'Студенткина', 'reader');

-- === ГРУППЫ ===
INSERT INTO auth_group (id, name) VALUES
(1, 'Администраторы'),
(2, 'Библиотекари'),
(3, 'Читатели');

-- === ПРИВЯЗКА ПОЛЬЗОВАТЕЛЕЙ К ГРУППАМ ===
INSERT INTO main_customuser_groups (customuser_id, group_id) VALUES
(1, 1), -- admin → Администраторы
(2, 2), -- librarian1 → Библиотекари
(3, 3); -- reader1 → Читатели

-- === ПРАВА ===
--INSERT INTO auth_permission (id, name, content_type_id, codename) VALUES
--(1, 'Can view book', 1, 'view_book'),
--(2, 'Can add book', 1, 'add_book'),
--(3, 'Can borrow book', 2, 'borrow_book');

-- === ПРИВЯЗКА ПРАВ К ПОЛЬЗОВАТЕЛЯМ ===
-- admin: все права
--INSERT INTO main_customuser_user_permissions (customuser_id, permission_id) VALUES
--(1, 1),
--(1, 2),
--(1, 3),
---- librarian1: добавлять книги
--(2, 2),
---- reader1: просматривать книги и бронировать
--(3, 1),
--(3, 3);

-- === БРОНИРОВАНИЯ ===
INSERT INTO main_booking (id, book_id, user_id, booking_date, status)
VALUES
(1, 1, 3, '2025-06-01', 'pending'),
(2, 2, 3, '2025-06-03', 'approved');

-- === СООБЩЕНИЯ ===
INSERT INTO main_message (id, name, email, message, date_sent)
VALUES
(1, 'Иван Иванов', 'ivan@example.com', 'Не могу войти в аккаунт.', '2025-06-05 12:00:00'),
(2, 'Мария Смирнова', 'maria@example.com', 'Когда будет доступна "1984"?', '2025-06-06 15:30:00');
