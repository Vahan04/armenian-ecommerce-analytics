\echo '--- Data quality checks: every query should return zero rows ---'

SELECT 'orphan order items' AS check_name, COUNT(*) AS failures
FROM order_items oi
LEFT JOIN orders o USING (order_id)
WHERE o.order_id IS NULL
HAVING COUNT(*) > 0;

SELECT 'negative inventory' AS check_name, COUNT(*) AS failures
FROM products
WHERE stock_quantity < 0
HAVING COUNT(*) > 0;

SELECT 'completed payment mismatch' AS check_name, COUNT(*) AS failures
FROM payments p
JOIN order_totals ot USING (order_id)
WHERE p.status = 'completed' AND p.amount_amd <> ot.subtotal_amd
HAVING COUNT(*) > 0;
