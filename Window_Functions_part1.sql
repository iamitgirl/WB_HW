-- Часть 1.
-- Список сотрудников с именами сотрудников, получающими самую высокую зарплату в отделе.
-- Без использования оконных функций (с использованием MAX).
WITH max_salary_per_industry AS (
    SELECT 
        industry, 
        MAX(salary) AS max_salary
    FROM 
        salary
    GROUP BY 
        industry
)
SELECT 
    s.first_name, 
    s.last_name, 
    s.salary, 
    s.industry, 
    CONCAT(max_employee.first_name, ' ', max_employee.last_name) AS name_highest_sal
FROM 
    salary s
JOIN 
    max_salary_per_industry ms ON s.industry = ms.industry AND s.salary = ms.max_salary
JOIN 
    salary max_employee ON max_employee.industry = s.industry AND max_employee.salary = ms.max_salary;
    
-- Список сотрудников с именами сотрудников, получающими самую высокую зарплату в отделе.
-- С использованием оконных функций (FIRST_VALUE).
WITH ranked_salaries AS (
    SELECT 
        first_name, 
        last_name, 
        salary, 
        industry, 
        FIRST_VALUE(CONCAT(first_name, ' ', last_name)) OVER (PARTITION BY industry ORDER BY salary DESC) AS name_highest_sal
    FROM 
        salary
)
SELECT 
    first_name, 
    last_name, 
    salary, 
    industry, 
    name_highest_sal
FROM 
    ranked_salaries
WHERE 
    salary = (SELECT MAX(salary) FROM salary WHERE industry = ranked_salaries.industry);
    
-- Список сотрудников с именами сотрудников, получающими самую низкую зарплату в отделе.
-- Без использования оконных функций (с использованием MIN).
WITH min_salary_per_industry AS (
    SELECT 
        industry, 
        MIN(salary) AS min_salary
    FROM 
        salary
    GROUP BY 
        industry
)
SELECT 
    s.first_name, 
    s.last_name, 
    s.salary, 
    s.industry, 
    CONCAT(min_employee.first_name, ' ', min_employee.last_name) AS name_lowest_sal
FROM 
    salary s
JOIN 
    min_salary_per_industry ms ON s.industry = ms.industry AND s.salary = ms.min_salary
JOIN 
    salary min_employee ON min_employee.industry = s.industry AND min_employee.salary = ms.min_salary;

-- Список сотрудников с именами сотрудников, получающими самую низкую зарплату в отделе.
-- С использованием оконных функций (FIRST_VALUE).
WITH ranked_salaries AS (
    SELECT 
        first_name, 
        last_name, 
        salary, 
        industry, 
        FIRST_VALUE(CONCAT(first_name, ' ', last_name)) OVER (PARTITION BY industry ORDER BY salary ASC) AS name_lowest_sal
    FROM 
        salary
)
SELECT 
    first_name, 
    last_name, 
    salary, 
    industry, 
    name_lowest_sal
FROM 
    ranked_salaries
WHERE 
    salary = (SELECT MIN(salary) FROM salary WHERE industry = ranked_salaries.industry);
    