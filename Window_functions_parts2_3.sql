-- Часть 2.
-- 1.
SELECT 
    s.SHOPNUMBER,
    sh.CITY,
    sh.ADDRESS,
    SUM(s.QTY) AS SUM_QTY,
    SUM(s.QTY * g.PRICE) AS SUM_QTY_PRICE
FROM 
    sales s
JOIN 
    shops sh ON s.SHOPNUMBER = sh.SHOPNUMBER
JOIN 
    goods g ON s.ID_GOOD = g.ID_GOOD
WHERE 
    s.DATE = '2/1/2016'
GROUP BY 
    s.SHOPNUMBER, sh.CITY, sh.ADDRESS
ORDER BY 
    s.SHOPNUMBER;
    
-- 2.
SELECT 
    s.DATE AS DATE_,
    sh.CITY,
    SUM(s.QTY * g.PRICE) / SUM(SUM(s.QTY * g.PRICE)) OVER (PARTITION BY s.DATE) AS SUM_SALES_REL
FROM 
    sales s
JOIN 
    goods g ON s.ID_GOOD = g.ID_GOOD
JOIN 
    shops sh ON s.SHOPNUMBER = sh.SHOPNUMBER
WHERE 
    g.CATEGORY = 'ЧИСТОТА'
GROUP BY 
    s.DATE, sh.CITY;

-- 3.
WITH RankedSales AS (
    SELECT 
        s.DATE AS DATE_,
        s.SHOPNUMBER,
        s.ID_GOOD,
        s.QTY,
        RANK() OVER (PARTITION BY s.DATE, s.SHOPNUMBER ORDER BY s.QTY DESC) AS rnk
    FROM 
        sales s
)
SELECT 
    DATE_,
    SHOPNUMBER,
    ID_GOOD
FROM 
    RankedSales
WHERE 
    rnk <= 3
ORDER BY 
    DATE_, SHOPNUMBER, rnk;

-- 4.
WITH PrevDaySales AS (
    SELECT 
        s.DATE AS DATE_,
        s.SHOPNUMBER,
        g.CATEGORY,
        SUM(s.QTY * g.PRICE) AS SALES_RUB,
        LAG(SUM(s.QTY * g.PRICE)) OVER (PARTITION BY s.SHOPNUMBER, g.CATEGORY ORDER BY s.DATE) AS PREV_SALES
    FROM 
        sales s
    JOIN 
        goods g ON s.ID_GOOD = g.ID_GOOD
    JOIN 
        shops sh ON s.SHOPNUMBER = sh.SHOPNUMBER
    WHERE 
        sh.CITY = 'СПб'
    GROUP BY 
        s.DATE, s.SHOPNUMBER, g.CATEGORY
)
SELECT 
    DATE_,
    SHOPNUMBER,
    CATEGORY,
    PREV_SALES
FROM 
    PrevDaySales
WHERE 
    PREV_SALES IS NOT NULL;


-- Часть 3.
-- Создадим таблицу query.
CREATE TABLE query (
    searchid SERIAL PRIMARY KEY,
    year INT,
    month INT,
    day INT,
    userid INT,
    ts BIGINT,
    devicetype VARCHAR(50),
    deviceid VARCHAR(50),
    query TEXT
);

-- Вставим в таблицу query данные.
INSERT INTO query (year, month, day, userid, ts, devicetype, deviceid, "query")
VALUES
(2024, 11, 24, 1, 1700816400, 'android', 'device_1', 'к'),
(2024, 11, 24, 1, 1700816460, 'android', 'device_1', 'ку'),
(2024, 11, 24, 1, 1700816520, 'android', 'device_1', 'куп'),
(2024, 11, 24, 1, 1700816580, 'android', 'device_1', 'купить'),
(2024, 11, 24, 1, 1700816680, 'android', 'device_1', 'купить кур'),
(2024, 11, 24, 1, 1700816800, 'android', 'device_1', 'купить куртку'),
(2024, 11, 24, 2, 1700816700, 'ios', 'device_2', 'платье'),
(2024, 11, 24, 2, 1700816800, 'ios', 'device_2', 'платье с цветами'),
(2024, 11, 24, 2, 1700816900, 'ios', 'device_2', 'платье синее'),
(2024, 11, 24, 1, 1700817000, 'android', 'device_1', 'зимние'),
(2024, 11, 24, 1, 1700817060, 'android', 'device_1', 'зимние кроссовки'),
(2024, 11, 24, 1, 1700817120, 'android', 'device_1', 'зимние кроссовки мужские'),
(2024, 11, 24, 2, 1700817200, 'ios', 'device_2', 'кроссовки'),
(2024, 11, 24, 2, 1700817300, 'ios', 'device_2', 'кроссовки женские'),
(2024, 11, 24, 2, 1700817400, 'ios', 'device_2', 'кроссовки женские черные'),
(2024, 11, 25, 3, 1700901000, 'android', 'device_3', 'игрушки'),
(2024, 11, 25, 3, 1700901060, 'android', 'device_3', 'игрушки детские'),
(2024, 11, 25, 3, 1700901120, 'android', 'device_3', 'игрушки для мальчиков'),
(2024, 11, 25, 3, 1700901180, 'android', 'device_3', 'машинка игрушка'),
(2024, 11, 25, 4, 1700902000, 'android', 'device_4', 'утюг'),
(2024, 11, 25, 4, 1700902060, 'android', 'device_4', 'утюг паровой'),
(2024, 11, 25, 4, 1700902120, 'android', 'device_4', 'утюг Tefal'),
(2024, 11, 25, 4, 1700902200, 'android', 'device_4', 'утюг Tefal GV'),
(2024, 11, 26, 5, 1700983000, 'web', 'device_5', 'телефон'),
(2024, 11, 26, 5, 1700983060, 'web', 'device_5', 'телефон Samsung'),
(2024, 11, 26, 5, 1700983120, 'web', 'device_5', 'телефон Samsung Galaxy'),
(2024, 11, 26, 5, 1700983180, 'web', 'device_5', 'Samsung Galaxy A54'),
(2024, 11, 27, 6, 1701064000, 'ios', 'device_6', 'телевизор'),
(2024, 11, 27, 6, 1701064060, 'ios', 'device_6', 'телевизор LG'),
(2024, 11, 27, 6, 1701064120, 'ios', 'device_6', 'телевизор LG 4K'),
(2024, 11, 27, 6, 1701064180, 'ios', 'device_6', 'телевизор LG 4K 55'),
(2024, 11, 28, 7, 1701145000, 'android', 'device_7', 'диван'),
(2024, 11, 28, 7, 1701145060, 'android', 'device_7', 'диван угловой'),
(2024, 11, 28, 7, 1701145120, 'android', 'device_7', 'диван угловой раскладной'),
(2024, 11, 28, 7, 1701145180, 'android', 'device_7', 'диван угловой раскладной недорого'),
(2024, 11, 28, 8, 1701146000, 'android', 'device_8', 'пылесос'),
(2024, 11, 28, 8, 1701146060, 'android', 'device_8', 'пылесос Xiaomi'),
(2024, 11, 28, 8, 1701146120, 'android', 'device_8', 'пылесос Xiaomi Mi'),
(2024, 11, 28, 8, 1701146180, 'android', 'device_8', 'пылесос Xiaomi Mi Robot');

-- Расчет столбца is_final.
WITH query_with_next AS (
    SELECT
        *,
        LEAD(ts) OVER (PARTITION BY userid, deviceid ORDER BY ts) AS next_ts,
        LEAD(query) OVER (PARTITION BY userid, deviceid ORDER BY ts) AS next_query,
        LENGTH(query) AS query_length,
        LENGTH(LEAD(query) OVER (PARTITION BY userid, deviceid ORDER BY ts)) AS next_query_length
    FROM
        query
),
query_with_conditions AS (
    SELECT
        *,
        CASE
            WHEN next_ts IS NULL THEN 1 -- Последний запрос
            WHEN (next_ts - ts) > 180 THEN 1 -- Более 3 минут до следующего запроса
            WHEN (next_ts - ts) > 60 AND next_query_length < query_length THEN 2 -- Следующий запрос короче и прошло > 1 минуты
            ELSE 0
        END AS is_final
    FROM
        query_with_next
)
SELECT
    year, month, day, userid, ts, devicetype, deviceid, query, next_query, is_final
FROM
    query_with_conditions
WHERE
    devicetype = 'android' AND is_final IN (1, 2) AND day = 24 AND month = 11 AND year = 2024;
