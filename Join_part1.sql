-- Часть 1.
-- Находим клиента с самым долгим временем ожидания между заказом и доставкой
SELECT 
    c.customer_id, 
    c.name, 
    o.order_id, 
    EXTRACT(EPOCH FROM (TO_TIMESTAMP(o.shipment_date, 'YYYY/MM/DD HH24:MI:SS') - TO_TIMESTAMP(o.order_date, 'YYYY/MM/DD HH24:MI:SS'))) / 86400 AS wait_time_in_days
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
WHERE 
    o.order_status = 'Approved'
ORDER BY 
    wait_time_in_days DESC
LIMIT 1;


-- Находим клиентов с наибольшим количеством заказов
SELECT 
    c.customer_id, 
    c.name, 
    COUNT(o.order_id) AS total_orders, 
    ROUND(AVG(EXTRACT(EPOCH FROM (TO_TIMESTAMP(o.shipment_date, 'YYYY/MM/DD HH24:MI:SS') - TO_TIMESTAMP(o.order_date, 'YYYY/MM/DD HH24:MI:SS'))) / 86400), 2) AS avg_wait_time_in_days, 
    SUM(o.order_ammount) AS total_order_amount
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
WHERE 
    o.order_status = 'Approved'
GROUP BY 
    c.customer_id, c.name
ORDER BY 
    total_order_amount DESC;
    
-- Находим клиентов с задержками более 5 дней и отмененными заказами  
SELECT 
    c.customer_id, 
    c.name, 
    COUNT(CASE WHEN o.order_status = 'Approved' AND EXTRACT(EPOCH FROM (TO_TIMESTAMP(o.shipment_date, 'YYYY/MM/DD HH24:MI:SS') - TO_TIMESTAMP(o.order_date, 'YYYY/MM/DD HH24:MI:SS'))) / 86400 > 5 THEN 1 END) AS delayed_deliveries, 
    COUNT(CASE WHEN o.order_status = 'Cancel' THEN 1 END) AS cancelled_orders, 
    SUM(o.order_ammount) AS total_order_amount
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.name
HAVING 
    COUNT(CASE WHEN o.order_status = 'Approved' AND EXTRACT(EPOCH FROM (TO_TIMESTAMP(o.shipment_date, 'YYYY/MM/DD HH24:MI:SS') - TO_TIMESTAMP(o.order_date, 'YYYY/MM/DD HH24:MI:SS'))) / 86400 > 5 THEN 1 END) > 0
    OR COUNT(CASE WHEN o.order_status = 'Cancel' THEN 1 END) > 0
ORDER BY 
    total_order_amount DESC;

