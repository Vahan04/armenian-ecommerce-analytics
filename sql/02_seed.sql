INSERT INTO categories (name) VALUES
    ('Books'), ('Electronics'), ('Home'), ('Armenian Products');

INSERT INTO customers (full_name, email, phone, city, registered_at) VALUES
    ('Ani Grigoryan', 'ani@example.am', '+37491111111', 'Yerevan', '2025-01-12'),
    ('Arman Sargsyan', 'arman@example.am', '+37492222222', 'Gyumri', '2025-01-20'),
    ('Mariam Hakobyan', 'mariam@example.am', '+37493333333', 'Vanadzor', '2025-02-03'),
    ('Narek Petrosyan', 'narek@example.am', '+37494444444', 'Yerevan', '2025-02-18'),
    ('Lilit Manukyan', 'lilit@example.am', '+37495555555', 'Abovyan', '2025-03-01'),
    ('Sona Mkrtchyan', 'sona@example.am', '+37496666666', 'Yerevan', '2025-03-11'),
    ('Gor Vardanyan', 'gor@example.am', '+37497777777', 'Hrazdan', '2025-03-25'),
    ('Elena Avetisyan', 'elena@example.am', '+37498888888', 'Dilijan', '2025-04-02'),
    ('Tigran Harutyunyan', 'tigran@example.am', '+37499999999', 'Yerevan', '2025-04-17'),
    ('Hasmik Galstyan', 'hasmik@example.am', '+37490000000', 'Artashat', '2025-05-06');

INSERT INTO products (category_id, name, description, price_amd, stock_quantity, reorder_level) VALUES
    (1, 'The Little Prince', 'Classic novel in Armenian translation', 3500, 18, 5),
    (1, 'Algorithms in C++', 'Competitive programming reference', 12000, 4, 6),
    (1, 'Physics Problems', 'University physics exercises', 8500, 7, 5),
    (1, 'Armenian History', 'Modern overview of Armenian history', 6500, 12, 4),
    (2, 'Wireless Headphones', 'Bluetooth over-ear headphones', 28000, 9, 5),
    (2, 'Mechanical Keyboard', 'Compact keyboard for programming', 24000, 3, 5),
    (2, 'USB-C Charger', '65W fast charger', 14000, 22, 8),
    (2, 'Power Bank', '10000 mAh portable battery', 11000, 14, 5),
    (3, 'Desk Lamp', 'LED lamp with adjustable brightness', 9000, 6, 4),
    (3, 'Travel Mug', 'Insulated stainless-steel mug', 7500, 16, 5),
    (3, 'Notebook Set', 'Three recycled-paper notebooks', 4200, 25, 8),
    (4, 'Armenian Coffee', 'Local roasted coffee, 250 g', 4800, 30, 10),
    (4, 'Dried Apricots', 'Armenian dried fruit, 500 g', 5200, 11, 5),
    (4, 'Honey from Tavush', 'Natural mountain honey, 400 g', 7000, 8, 4);

INSERT INTO orders (customer_id, ordered_at, status, delivery_city) VALUES
    (1, '2025-06-02 10:15+04', 'delivered', 'Yerevan'),
    (2, '2025-06-05 13:20+04', 'delivered', 'Gyumri'),
    (3, '2025-06-18 09:10+04', 'delivered', 'Vanadzor'),
    (1, '2025-07-03 16:40+04', 'delivered', 'Yerevan'),
    (4, '2025-07-12 11:05+04', 'delivered', 'Yerevan'),
    (5, '2025-07-28 18:25+04', 'shipped', 'Abovyan'),
    (6, '2025-08-04 12:00+04', 'delivered', 'Yerevan'),
    (2, '2025-08-19 15:45+04', 'delivered', 'Gyumri'),
    (7, '2025-09-01 10:30+04', 'paid', 'Hrazdan'),
    (8, '2025-09-14 14:15+04', 'cancelled', 'Dilijan'),
    (9, '2025-10-02 17:05+04', 'delivered', 'Yerevan'),
    (10, '2025-10-21 09:50+04', 'pending', 'Artashat');

INSERT INTO order_items (order_id, product_id, quantity, unit_price_amd) VALUES
    (1, 1, 2, 3500), (1, 12, 1, 4800),
    (2, 2, 1, 12000), (2, 11, 2, 4200),
    (3, 5, 1, 28000), (3, 13, 2, 5200),
    (4, 3, 1, 8500), (4, 4, 1, 6500),
    (5, 6, 1, 24000), (5, 7, 1, 14000),
    (6, 10, 2, 7500), (6, 14, 1, 7000),
    (7, 12, 3, 4800), (7, 13, 1, 5200),
    (8, 1, 1, 3500), (8, 5, 1, 28000),
    (9, 9, 1, 9000), (9, 11, 3, 4200),
    (10, 14, 1, 7000),
    (11, 2, 1, 12000), (11, 8, 1, 11000),
    (12, 3, 2, 8500);

INSERT INTO payments (order_id, paid_at, amount_amd, method, status)
SELECT order_id, ordered_at, SUM(quantity * unit_price_amd),
       CASE WHEN order_id IN (1, 4, 7, 11) THEN 'idram' ELSE 'card' END,
       CASE WHEN status = 'cancelled' THEN 'refunded'
            WHEN status = 'pending' THEN 'pending' ELSE 'completed' END
FROM orders JOIN order_items USING (order_id)
GROUP BY order_id, ordered_at, status;

INSERT INTO deliveries (order_id, courier, delivery_fee_amd, status, delivered_at) VALUES
    (1, 'HayPost', 1000, 'delivered', '2025-06-04 15:00+04'),
    (2, 'HayPost', 1500, 'delivered', '2025-06-08 12:30+04'),
    (3, 'Onex', 1500, 'delivered', '2025-06-20 16:20+04'),
    (4, 'HayPost', 1000, 'delivered', '2025-07-05 13:10+04'),
    (5, 'Onex', 1000, 'delivered', '2025-07-14 11:30+04'),
    (6, 'HayPost', 1000, 'in_transit', NULL),
    (7, 'HayPost', 1000, 'delivered', '2025-08-06 14:00+04'),
    (8, 'Onex', 1500, 'delivered', '2025-08-22 10:00+04'),
    (9, 'HayPost', 2000, 'preparing', NULL),
    (10, 'Onex', 2000, 'returned', NULL),
    (11, 'HayPost', 1000, 'delivered', '2025-10-04 12:00+04'),
    (12, 'HayPost', 1500, 'preparing', NULL);
