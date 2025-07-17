/*Добавьте в этот файл все запросы, для создания схемы сafe и
 таблиц в ней в нужном порядке*/
--Создание схемы cafe--
CREATE SCHEMA IF NOT EXISTS cafe;


CREATE TYPE cafe.restaurant_type AS ENUM
    (
    'coffee_shop',
    'restaurant',
    'bar',
    'pizzeria'
    );

CREATE TABLE cafe.restaurants (
    restaurant_uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    type cafe.restaurant_type NOT NULL,
    menu JSONB
);

CREATE TABLE cafe.managers (
    manager_uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20)
);

CREATE TABLE cafe.restaurant_manager_work_dates (
    restaurant_uuid UUID NOT NULL,
    manager_uuid UUID NOT NULL,
    start_date DATE NOT NULL,  -- дата начала работы
    end_date DATE,            -- дата окончания работы (NULL, если работает сейчас)
    PRIMARY KEY (restaurant_uuid, manager_uuid),
    FOREIGN KEY (restaurant_uuid) REFERENCES cafe.restaurants(restaurant_uuid),
    FOREIGN KEY (manager_uuid) REFERENCES cafe.managers(manager_uuid),
    CHECK (start_date <= end_date OR end_date IS NULL)  -- проверка дат
);

CREATE TABLE cafe.sales (
 date DATE NOT NULL,
 restaurant_uuid UUID NOT NULL,
 avg_check NUMERIC(10, 2) NOT NULL, -- средний чек с точностью до копеек
 PRIMARY KEY (date, restaurant_uuid),
 FOREIGN KEY (restaurant_uuid) REFERENCES cafe.restaurants(restaurant_uuid)
);