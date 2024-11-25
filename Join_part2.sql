-- Часть 2.
-- Вычисляем общую сумму продаж для каждой категории продуктов.
SELECT 
    p.product_category, 
    SUM(o.order_ammount) AS total_sales
FROM 
    orders o
JOIN 
    products p ON o.product_id = p.product_id
GROUP BY 
    p.product_category
ORDER BY 
    total_sales DESC;
    
-- Определяем категорию продукта с наибольшей общей суммой продаж.
SELECT 
    product_category, 
    total_sales
FROM (
    SELECT 
        p.product_category, 
        SUM(o.order_ammount) AS total_sales
    FROM 
        orders o
    JOIN 
        products p ON o.product_id = p.product_id
    GROUP BY 
        p.product_category
) AS category_sales
ORDER BY 
    total_sales DESC
LIMIT 1;

-- Для каждой категории продуктов, определяем продукт с максимальной суммой продаж в этой категории.
WITH product_sales AS (
    SELECT 
        o.product_id, 
        SUM(o.order_ammount) AS total_sales
    FROM 
        orders o
    GROUP BY 
        o.product_id
),
category_max_sales AS (
    SELECT 
        p.product_category, 
        MAX(ps.total_sales) AS max_sales_in_category
    FROM 
        product_sales ps
    JOIN 
        products p ON ps.product_id = p.product_id
    GROUP BY 
        p.product_category
)
SELECT 
    p.product_category, 
    p.product_name, 
    ps.total_sales AS product_sales
FROM 
    product_sales ps
JOIN 
    products p ON ps.product_id = p.product_id
JOIN 
    category_max_sales cms ON p.product_category = cms.product_category
WHERE 
    ps.total_sales = cms.max_sales_in_category
ORDER BY 
    p.product_category, product_sales DESC;

