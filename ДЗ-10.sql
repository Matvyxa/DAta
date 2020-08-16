use shop;
-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
-- catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы,
-- идентификатор первичного ключа и содержимое поля name.

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME NOT NULL,
	table_name VARCHAR(45) NOT NULL,
	str_id INT(20) NOT NULL,
	name_value VARCHAR(45) NOT NULL
) ENGINE = ARCHIVE;

DROP TRIGGER IF EXISTS watchlog_users;
delimiter //
CREATE TRIGGER watchlog_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'users', NEW.id, NEW.name);
END //
delimiter ;

DROP TRIGGER IF EXISTS watchlog_catalogs;
delimiter //
CREATE TRIGGER watchlog_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END //
delimiter ;

delimiter //
CREATE TRIGGER watchlog_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'products', NEW.id, NEW.name);
END //
delimiter ;

SELECT * FROM users;
SELECT * FROM logs;

INSERT INTO users (name, birthday_at)
VALUES ('Кнехт', '1900-01-01');

SELECT * FROM users;
SELECT * FROM logs;

INSERT INTO users (name, birthday_at)
VALUES ('Garry', '1900-01-01'),
		('Ron', '1103-01-01'),
		('Germiona', '1111-01-01'),
		('Xagrid', '0000-00-01');
        
SELECT * FROM users;
SELECT * FROM logs;

SELECT * FROM catalogs;
SELECT * FROM logs;

INSERT INTO catalogs (name)
VALUES ('Блоки питания'),
	('Аксессуары');
    
SELECT * FROM catalogs;
SELECT * FROM logs;

INSERT INTO products (name, description, price, catalog_id)
VALUES ('DARK ROCK PRO 4 (BK022)', 'блок питания', 500.00, 14),
		('Коврик', 'Коврик для мыши', 150.00, 15);
        
SELECT * FROM catalogs;
SELECT * FROM logs;

-- 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
SADD ip '127.0.0.1' '127.0.0.2' '127.0.0.3'
-- Невозможно добавить в коллекцию уже имеющиейся в ней ip адрес, только уникальные значения
SADD ip '127.0.0.1' 
-- просмотрим список уникальных ip
SMEMBERS ip
-- кол-во адресов в коллекции
SCARD ip

-- 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу
-- и наоброт, поиск электронного адреса пользователя по его имени.

set Matvyxa@mail.ru Matvyxa 
set Matvyxa Matvyxa@mail.ru

get Matvyxa@mail.ru 
get Matvyxa

-- 3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
-- Так как в плане выбора структуры БД mongodb дает широкий выбор,
-- то оптимальных вариантов организации структуры БД может довольно много, все зависит от предметной области

use products
db.products.insert({"name": "Intel Core i7-9900", "description": "Процессор для настольных ПК", "price": "30000.00", "catalog_id": "Процессоры", "created_at": new Date(), "updated_at": new Date()}) 

db.products.insertMany([
	{"name": "AMD FX-8320", "description": "Процессор для настольных ПК", "price": "4000.00", "catalog_id": "Процессоры", "created_at": new Date(), "updated_at": new Date()},
	{"name": "AMD FX-8320E", "description": "Процессор для настольных ПК", "price": "4500.00", "catalog_id": "Процессоры", "created_at": new Date(), "updated_at": new Date()}])

db.products.find().pretty()
db.products.find({name: "AMD FX-8320"}).pretty()

use catalogs
db.catalogs.insertMany([{"name": "Процессоры"}, {"name": "Мат.платы"}, {"name": "Видеокарты"}])
