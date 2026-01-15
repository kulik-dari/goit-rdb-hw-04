-- ========================================
-- Домашнє завдання 4: DML та DDL команди
-- goit-rdb-hw-04
-- Автор: Kulik Daria
-- ========================================

-- ========================================
-- ЗАВДАННЯ 1: Створення бази даних LibraryManagement
-- ========================================

-- Створюємо базу даних
DROP DATABASE IF EXISTS LibraryManagement;
CREATE DATABASE LibraryManagement;
USE LibraryManagement;

-- Таблиця "authors" (автори)
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(255) NOT NULL
);

-- Таблиця "genres" (жанри)
CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL
);

-- Таблиця "books" (книги)
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publication_year SMALLINT,
    author_id INT,
    genre_id INT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

-- Таблиця "users" (користувачі)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL
);

-- Таблиця "borrowed_books" (позичені книги)
CREATE TABLE borrowed_books (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    user_id INT,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


-- ========================================
-- ЗАВДАННЯ 2: Заповнення таблиць тестовими даними
-- ========================================

-- Додаємо авторів
INSERT INTO authors (author_name) VALUES
('J.K. Rowling'),
('George Orwell'),
('Jane Austen');

-- Додаємо жанри
INSERT INTO genres (genre_name) VALUES
('Fantasy'),
('Dystopian'),
('Romance');

-- Додаємо книги
INSERT INTO books (title, publication_year, author_id, genre_id) VALUES
('Harry Potter and the Philosopher''s Stone', 1997, 1, 1),
('1984', 1949, 2, 2),
('Pride and Prejudice', 1813, 3, 3);

-- Додаємо користувачів
INSERT INTO users (username, email) VALUES
('alice_wonder', 'alice@example.com'),
('bob_smith', 'bob@example.com');

-- Додаємо записи про позичені книги
INSERT INTO borrowed_books (book_id, user_id, borrow_date, return_date) VALUES
(1, 1, '2025-01-01', '2025-01-15'),
(2, 2, '2025-01-10', NULL);

-- Перевірка даних
SELECT * FROM authors;
SELECT * FROM genres;
SELECT * FROM books;
SELECT * FROM users;
SELECT * FROM borrowed_books;


-- ========================================
-- ЗАВДАННЯ 3: JOIN всіх таблиць з homework_db
-- ========================================

USE homework_db;

-- Об'єднуємо всі 8 таблиць через INNER JOIN
SELECT 
    od.id AS order_detail_id,
    od.order_id,
    od.product_id,
    od.quantity,
    o.date AS order_date,
    o.customer_id,
    o.employee_id,
    o.shipper_id,
    c.name AS customer_name,
    c.contact AS customer_contact,
    c.address AS customer_address,
    c.city AS customer_city,
    c.postal_code AS customer_postal,
    c.country AS customer_country,
    p.name AS product_name,
    p.supplier_id,
    p.category_id,
    p.unit AS product_unit,
    p.price AS product_price,
    cat.name AS category_name,
    cat.description AS category_description,
    e.employee_id,
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    e.birthdate AS employee_birthdate,
    e.photo AS employee_photo,
    e.notes AS employee_notes,
    s.name AS shipper_name,
    s.phone AS shipper_phone,
    sup.name AS supplier_name,
    sup.contact AS supplier_contact,
    sup.address AS supplier_address,
    sup.city AS supplier_city,
    sup.postal_code AS supplier_postal,
    sup.country AS supplier_country,
    sup.phone AS supplier_phone
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers s ON o.shipper_id = s.id
INNER JOIN suppliers sup ON p.supplier_id = sup.id;


-- ========================================
-- ЗАВДАННЯ 4: Аналіз та модифікація запитів
-- ========================================

-- 4.1: Визначити кількість рядків (COUNT)
SELECT COUNT(*) AS total_rows
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers s ON o.shipper_id = s.id
INNER JOIN suppliers sup ON p.supplier_id = sup.id;


-- 4.2: Змінюємо INNER JOIN на LEFT JOIN
-- Приклад зміни з INNER на LEFT JOIN
SELECT COUNT(*) AS total_rows_left_join
FROM order_details od
LEFT JOIN orders o ON od.order_id = o.id
LEFT JOIN customers c ON o.customer_id = c.id
LEFT JOIN products p ON od.product_id = p.id
LEFT JOIN categories cat ON p.category_id = cat.id
LEFT JOIN employees e ON o.employee_id = e.employee_id
LEFT JOIN shippers s ON o.shipper_id = s.id
LEFT JOIN suppliers sup ON p.supplier_id = sup.id;


-- 4.3: Фільтрація за employee_id > 3 AND <= 10
SELECT 
    od.id AS order_detail_id,
    od.order_id,
    od.product_id,
    od.quantity,
    o.employee_id,
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    c.name AS customer_name,
    p.name AS product_name,
    cat.name AS category_name
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers s ON o.shipper_id = s.id
INNER JOIN suppliers sup ON p.supplier_id = sup.id
WHERE o.employee_id > 3 AND o.employee_id <= 10;


-- 4.4: Групування за категорією, підрахунок рядків та середньої кількості
SELECT 
    cat.name AS category_name,
    COUNT(*) AS row_count,
    AVG(od.quantity) AS average_quantity
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers s ON o.shipper_id = s.id
INNER JOIN suppliers sup ON p.supplier_id = sup.id
WHERE o.employee_id > 3 AND o.employee_id <= 10
GROUP BY cat.name;


-- 4.5: Фільтрація груп де середня кількість > 21
SELECT 
    cat.name AS category_name,
    COUNT(*) AS row_count,
    AVG(od.quantity) AS average_quantity
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers s ON o.shipper_id = s.id
INNER JOIN suppliers sup ON p.supplier_id = sup.id
WHERE o.employee_id > 3 AND o.employee_id <= 10
GROUP BY cat.name
HAVING AVG(od.quantity) > 21;


-- 4.6: Сортування за спаданням кількості рядків
SELECT 
    cat.name AS category_name,
    COUNT(*) AS row_count,
    AVG(od.quantity) AS average_quantity
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers s ON o.shipper_id = s.id
INNER JOIN suppliers sup ON p.supplier_id = sup.id
WHERE o.employee_id > 3 AND o.employee_id <= 10
GROUP BY cat.name
HAVING AVG(od.quantity) > 21
ORDER BY row_count DESC;


-- 4.7: Вивести 4 рядки з пропущеним першим (LIMIT 4 OFFSET 1)
SELECT 
    cat.name AS category_name,
    COUNT(*) AS row_count,
    AVG(od.quantity) AS average_quantity
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers s ON o.shipper_id = s.id
INNER JOIN suppliers sup ON p.supplier_id = sup.id
WHERE o.employee_id > 3 AND o.employee_id <= 10
GROUP BY cat.name
HAVING AVG(od.quantity) > 21
ORDER BY row_count DESC
LIMIT 4 OFFSET 1;
