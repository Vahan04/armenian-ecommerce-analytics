\echo '--- Monthly revenue ---'
SELECT date_trunc('month', ordered_at)::DATE AS month,
       COUNT(*) AS orders,
       SUM(subtotal_amd) AS revenue_amd
FROM order_totals
WHERE status <> 'cancelled'
GROUP BY 1
ORDER BY 1;

\echo '--- Running monthly revenue ---'
WITH monthly AS (
    SELECT date_trunc('month', ordered_at)::DATE AS month,
           SUM(subtotal_amd) AS revenue_amd
    FROM order_totals
    WHERE status <> 'cancelled'
    GROUP BY 1
)
SELECT month, revenue_amd,
       SUM(revenue_amd) OVER (ORDER BY month) AS running_revenue_amd
FROM monthly
ORDER BY month;

\echo '--- Best-selling products ---'
SELECT p.name, SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.unit_price_amd) AS revenue_amd
FROM order_items oi
JOIN products p USING (product_id)
JOIN orders o USING (order_id)
WHERE o.status <> 'cancelled'
GROUP BY p.product_id, p.name
ORDER BY units_sold DESC, revenue_amd DESC
LIMIT 10;

\echo '--- Customer lifetime value ---'
SELECT * FROM customer_lifetime_value
ORDER BY lifetime_value_amd DESC;

\echo '--- Revenue by Armenian city ---'
SELECT delivery_city, COUNT(*) AS order_count,
       SUM(subtotal_amd) AS revenue_amd
FROM order_totals
WHERE status <> 'cancelled'
GROUP BY delivery_city
ORDER BY revenue_amd DESC;

\echo '--- Low-stock alerts ---'
SELECT * FROM inventory_alerts
ORDER BY stock_quantity, name;

\echo '--- Payment status summary ---'
SELECT method, status, COUNT(*) AS payment_count,
       SUM(amount_amd) AS amount_amd
FROM payments
GROUP BY method, status
ORDER BY method, status;
