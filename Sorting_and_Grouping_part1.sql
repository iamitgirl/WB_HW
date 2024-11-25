-- Часть 1.
-- Создаем запрос для подсчета числа пользователей из каждого города,
-- разделяем их на возрастные категории и группируем по этим категориям.
SELECT 
    city, 
    CASE 
        WHEN age BETWEEN 0 AND 20 THEN 'young'
        WHEN age BETWEEN 21 AND 49 THEN 'adult'
        WHEN age >= 50 THEN 'old'
    END AS age_category,
    COUNT(*) AS num_users
FROM 
    users
GROUP BY 
    city, age_category
ORDER BY 
    city, num_users DESC;

-- Вычисляем среднюю цену товаров, в названиях которых есть слова "hair" или "home",
-- и группируем по категориям.
SELECT 
    ROUND(CAST(AVG(price) AS numeric), 2) AS avg_price,
    category
FROM 
    products
WHERE 
    LOWER(name) LIKE '%hair%' OR LOWER(name) LIKE '%home%'
GROUP BY 
    category;