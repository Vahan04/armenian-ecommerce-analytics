CREATE OR REPLACE VIEW order_totals AS
SELECT
    o.order_id,
    o.customer_id,
    o.ordered_at,
    o.status,
    o.delivery_city,
    COALESCE(SUM(oi.quantity * oi.unit_price_amd), 0)::NUMERIC(12, 2) AS subtotal_amd
FROM orders o
LEFT JOIN order_items oi USING (order_id)
GROUP BY o.order_id;

CREATE OR REPLACE VIEW customer_lifetime_value AS
SELECT
    c.customer_id,
    c.full_name,
    c.city,
    COUNT(ot.order_id) FILTER (WHERE ot.status <> 'cancelled') AS order_count,
    COALESCE(SUM(ot.subtotal_amd) FILTER (WHERE ot.status <> 'cancelled'), 0)::NUMERIC(12, 2)
        AS lifetime_value_amd
FROM customers c
LEFT JOIN order_totals ot USING (customer_id)
GROUP BY c.customer_id, c.full_name, c.city;

CREATE OR REPLACE VIEW inventory_alerts AS
SELECT p.product_id, p.name, c.name AS category, p.stock_quantity, p.reorder_level
FROM products p
JOIN categories c USING (category_id)
WHERE p.active AND p.stock_quantity <= p.reorder_level;
