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
    ROUND(AVG(price), 2) AS avg_price,
    category
FROM 
    products
WHERE 
    LOWER(name) LIKE '%hair%' OR LOWER(name) LIKE '%home%'
GROUP BY 
    category;

-- Часть 2.
-- Дату регистрации  продавца определяем как наименьшее из всех дат регистрации для каждого продавца.
-- Выбираем количество категорий, средний рейтинг и суммарную выручку по каждому продавцу,
-- исключая категорию "Bedding". Определяем тип продавца как 'rich' или 'poor'.
SELECT 
    seller_id, 
    COUNT(DISTINCT category) AS total_categ,
    ROUND(AVG(rating), 2) AS avg_rating,
    SUM(revenue) AS total_revenue,
    CASE 
        WHEN COUNT(DISTINCT category) > 1 AND SUM(revenue) > 50000 THEN 'rich'
        WHEN COUNT(DISTINCT category) > 1 AND SUM(revenue) <= 50000 THEN 'poor'
    END AS seller_type
FROM 
    sellers
WHERE 
    category != 'Bedding'
GROUP BY 
    seller_id
HAVING 
    COUNT(DISTINCT category) > 1
ORDER BY 
    seller_id;
    
-- Рассчитываем количество полных месяцев с даты регистрации для неуспешных продавцов,
-- а также разницу между максимальным и минимальным сроком доставки.
SELECT 
    seller_id, 
    FLOOR((EXTRACT(EPOCH FROM (CURRENT_DATE - MIN(TO_DATE(date_reg, 'DD/MM/YYYY')))) / 86400) / 30) AS month_from_registration, 
    (SELECT MAX(delivery_days) - MIN(delivery_days) 
     FROM sellers 
     WHERE category != 'Bedding' 
       AND seller_id IN (
           SELECT seller_id
           FROM sellers
           WHERE category != 'Bedding'
           GROUP BY seller_id
           HAVING COUNT(DISTINCT category) > 1 AND SUM(revenue) <= 50000
       )) AS max_delivery_difference
FROM 
    sellers
WHERE 
    category != 'Bedding' 
    AND seller_id IN (
        SELECT seller_id
        FROM sellers
        WHERE category != 'Bedding'
        GROUP BY seller_id
        HAVING COUNT(DISTINCT category) > 1 AND SUM(revenue) <= 50000
    )
GROUP BY 
    seller_id
ORDER BY 
    seller_id;
    
-- Выбираем продавцов, зарегистрированных в 2022 году, продающих ровно 2 категории товаров
-- и имеющих суммарную выручку более 75,000. Формируем пары категорий.

SELECT 
    seller_id, 
    STRING_AGG(DISTINCT category, ' - ' ORDER BY category) AS category_pair
FROM 
    sellers
WHERE 
    category != 'Bedding'
    AND DATE_PART('year', TO_DATE(date_reg, 'DD/MM/YYYY')) = 2022
GROUP BY 
    seller_id
HAVING 
    COUNT(DISTINCT category) = 2
    AND SUM(revenue) > 75000
ORDER BY 
    seller_id;