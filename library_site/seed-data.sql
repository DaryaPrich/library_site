-- === ОЧИСТКА ПРИЛОЖЕНИЯ ===
DELETE FROM main_booking;
DELETE FROM main_message;
DELETE FROM main_readhistory;
DELETE FROM main_book_genres;
DELETE FROM main_book;
DELETE FROM main_genre;
DELETE FROM main_literaturetype;
DELETE FROM main_customuser_groups;
DELETE FROM main_customuser_user_permissions;
DELETE FROM main_customuser;
DELETE FROM auth_group;

-- === СБРОС АВТОИНКРЕМЕНТА ===
DELETE FROM sqlite_sequence WHERE name IN (
    'main_literaturetype', 'main_genre',
    'main_book', 'main_customuser', 'main_message',
    'main_booking', 'main_readhistory', 'auth_group'
);


-- === ТИПЫ ЛИТЕРАТУРЫ ===
INSERT INTO main_literaturetype (id, name) VALUES
(1, 'Художественная литература'),
(2, 'Научная литература'),
(3, 'Научно-популярная литература'),
(4, 'Справочная литература'),
(5, 'Учебная литература'),
(6, 'Документальная проза и мемуары'),
(7, 'Публицистика');

-- === ЖАНРЫ ===
INSERT INTO main_genre (id, name) VALUES
(1, 'Детектив'),
(2, 'Фэнтези'),
(3, 'Роман'),
(4, 'Любовный роман'),
(5, 'Приключения');

-- === КНИГИ ===
INSERT INTO main_book (
    id, title, author, isbn, year, description, cover_image,
    literature_type_id, file_url
)
VALUES
-- Фантастика (художественная литература)
(1, '1984', 'Джордж Оруэлл', '978-5-17-118366-1', 1949,
 'Антиутопия о тоталитарном обществе.',
 'https://covers.storytel.com/jpg-640/9782291090830.58b5cb0d-d3ca-43e2-bfa7-4095b5a0ef41?optimize=high&quality=70&width=600',
 1,
 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),

(4, 'Марсианин', 'Энди Вейер', '978-5-389-09706-7', 2011,
 'Инженер-ботаник выживает на Марсе.',
 'https://covers.storytel.com/jpg-640/9785171282417.4516bbb5-4b85-4f45-a134-82062212ca9e?optimize=high&quality=70&width=600',
 1,
 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),

(5, 'Дюна', 'Фрэнк Герберт', '978-5-17-083845-6', 1965,
 'Эпическая сага о пустынной планете.',
 'https://covers.storytel.com/jpg-640/9788726772647.e7920256-7c11-47f4-bb5d-c31d6f423791?optimize=high&quality=70&width=600',
 1,
 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),

(6, '451 градус по Фаренгейту', 'Рэй Брэдбери', '978-5-17-087107-1', 1953,
 'Общество, где книги под запретом.',
 'https://covers.storytel.com/jpg-640/9786257737241.8922d681-e9a6-45a2-90b5-3944f5431eaa?optimize=high&quality=70&width=600',
 1,
 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),

(7, 'Автостопом по галактике', 'Дуглас Адамс', '978-5-389-09211-6', 1979,
 'Юмористическое путешествие по Вселенной.',
 'https://img.freepik.com/premium-vector/book-icon-black-line-art-vector-logo_1223784-35762.jpg',
 1,
 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),

-- Наука (научная литература)
(2, 'Краткая история времени', 'Стивен Хокинг', '978-5-17-118367-8', 1988,
 'О природе времени и вселенной.',
 'https://img.freepik.com/premium-vector/book-icon-black-line-art-vector-logo_1223784-35762.jpg',
 2,
 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),

(8, 'Эгоистичный ген', 'Ричард Докинз', '978-5-17-057875-8', 1976,
 'О биологии и эволюции.',
 'https://img.freepik.com/premium-vector/book-icon-black-line-art-vector-logo_1223784-35762.jpg',
 2,
 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),

(9, 'Параллельные миры', 'Митио Каку', '978-5-389-05310-0', 2005,
 'Физика многомерных вселенных.',
 'https://img.freepik.com/premium-vector/book-icon-black-line-art-vector-logo_1223784-35762.jpg',
 2,
 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),

(10, 'Структура научных революций', 'Томас Кун', '978-5-02-025451-3', 1962,
 'Парадигмы в науке.',
 'https://img.freepik.com/premium-vector/book-icon-black-line-art-vector-logo_1223784-35762.jpg',
 2,
 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),

(11, 'Самая красивая история о науке', 'Юбер Рив', '978-5-699-27586-2', 2007,
 'Наука для всех.',
 'https://img.freepik.com/premium-vector/book-icon-black-line-art-vector-logo_1223784-35762.jpg',
 2,
 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),

-- История (научно-популярная литература)
(3, 'История России', 'Николай Карамзин', '978-5-17-118368-5', 1816,
 'Классический исторический труд.',
 'https://img.freepik.com/premium-vector/book-icon-black-line-art-vector-logo_1223784-35762.jpg',
 3,
 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),

(12, 'Государь', 'Никколо Макиавелли', '978-5-389-02029-4', 1532,
 'Политическая философия.',
 'https://img.freepik.com/premium-vector/book-icon-black-line-art-vector-logo_1223784-35762.jpg',
 3,
 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),

(13, 'История Европы', 'Норман Дэвис', '978-5-17-070816-1', 1996,
 'Обширный труд по европейской истории.',
 'https://img.freepik.com/premium-vector/book-icon-black-line-art-vector-logo_1223784-35762.jpg',
 3,
 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),

(14, 'Вторая мировая война', 'Уинстон Черчилль', '978-5-699-03474-3', 1948,
 'Мемуары и анализ событий.',
 'https://img.freepik.com/premium-vector/book-icon-black-line-art-vector-logo_1223784-35762.jpg',
 3,
 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),

(15, 'История древнего мира', 'Иван Артамонов', '978-5-17-060343-5', 1954,
 'История античных цивилизаций.',
 'https://img.freepik.com/premium-vector/book-icon-black-line-art-vector-logo_1223784-35762.jpg',
 3,
 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf');


-- === ЖАНРЫ ДЛЯ КНИГ ===
INSERT INTO main_book_genres (book_id, genre_id) VALUES
(1, 3), (1, 5),      -- 1984: роман, приключения
(4, 5),              -- Марсианин: приключения
(5, 2), (5, 3),      -- Дюна: фэнтези, роман
(6, 3),              -- 451°: роман
(7, 5),              -- Автостопом: приключения
(2, 3),              -- Краткая история времени: роман (условно)
(8, 3),              -- Эгоистичный ген: роман (условно)
(9, 3),              -- Параллельные миры: роман (условно)
(10, 3),             -- Структура научных революций: роман (условно)
(11, 3),             -- Самая красивая история о науке: роман
(3, 3),              -- История России: роман
(12, 3),             -- Государь: роман
(13, 3),             -- История Европы: роман
(14, 1),             -- Вторая мировая война: детектив (условно)
(15, 3);             -- История древнего мира: роман

-- === ПОЛЬЗОВАТЕЛИ ===
INSERT INTO main_customuser (
    id, password, is_superuser, username, email, is_staff, is_active, date_joined,
    first_name, last_name, role
) VALUES
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

INSERT INTO main_customuser_groups (customuser_id, group_id) VALUES
(1, 1),
(2, 2),
(3, 3);

-- === БРОНИРОВАНИЯ ===
INSERT INTO main_booking (id, book_id, user_id, booking_date, status) VALUES
(1, 1, 3, '2025-06-01', 'pending'),
(2, 2, 3, '2025-06-03', 'approved');

-- === СООБЩЕНИЯ ===
INSERT INTO main_message (id, name, email, message, date_sent) VALUES
(1, 'Иван Иванов', 'ivan@example.com', 'Не могу войти в аккаунт.', '2025-06-05 12:00:00'),
(2, 'Мария Смирнова', 'maria@example.com', 'Когда будет доступна "1984"?', '2025-06-06 15:30:00');
