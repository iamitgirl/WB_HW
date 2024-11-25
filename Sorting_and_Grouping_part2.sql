-- Часть 2.
-- Дату регистрации  продавца определяем как наименьшее из всех дат регистрации для каждого продавца.
-- Выбираем количество категорий, средний рейтинг и суммарную выручку по каждому продавцу,
-- исключая категорию "Bedding". Определяем тип продавца как 'rich' или 'poor'.
SELECT 
    seller_id, 
    COUNT(DISTINCT category) AS total_categ,
    ROUND(CAST(AVG(rating) AS numeric), 2) AS avg_rating,
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
    MAX(TO_DATE(date, 'DD/MM/YYYY')) - MIN(TO_DATE(date_reg, 'DD/MM/YYYY')) AS days_difference,
    FLOOR((EXTRACT(EPOCH FROM (CURRENT_DATE - MIN(TO_DATE(date_reg, 'DD/MM/YYYY'))::timestamp)) / 86400) / 30) AS month_from_registration,
    (
        SELECT MAX(delivery_days) - MIN(delivery_days)
        FROM sellers
        WHERE category != 'Bedding'
          AND seller_id IN (
              SELECT seller_id
              FROM sellers
              WHERE category != 'Bedding'
              GROUP BY seller_id
              HAVING COUNT(DISTINCT category) > 1 AND SUM(revenue) <= 50000
          )
    ) AS max_delivery_difference
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