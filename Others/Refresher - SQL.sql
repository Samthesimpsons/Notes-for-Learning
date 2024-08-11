SELECT
COUNT(DISTINCT t1.column) AS row_count,

-- String counts number of characters
-- Json counts number of items
LENGTH(t1.column) AS num_items,

-- Returns 1st none null value
COALESCE(t1.column, 0) AS no_null_column,

IF(
	t1.date_column IS NULL,
	0,
	-- date_1 - date_2
	DATEDIFF(NOW(), t1.date_column)
) 
AS days_difference,

DATE_FORMAT(t1.dates, '%Y-%m') AS month_date,

-- AVG, MIN, MAX aggregation functions
SUM(t1.column) OVER (ORDER BY t1.id) as cumulative_sum,
LAG(t1.column, 1) OVER (ORDER BY t1.id) AS column_next_value,

-- DENSE_RANK() does not skip number    e.g. 1 1 2 3
-- RANK()       skips number            e.g. 1 1 3 4
-- ROW_NUMBER() uses unique number      e.g. 1 2 3 4
DENSE_RANK() OVER (PARTITION BY t1.id ORDER BY t1.column1 ASC) AS ranking,

-- Can be placed within agg functions like sum(case when ...)
CASE
	WHEN t1.column2 < 3 THEN 1
	ELSE 0 END
AS indicator_column,

-- MOD, DIV
t1.column MOD 7 AS modulo_remainder,
t1.column DIV 7 AS integer_division,

-- CONCAT_WS("seperator", col1, ..)
CONCAT(
	UPPER(SUBSTRING(t1.name, 1, 1)), 
	LOWER(SUBSTRING(t1.name, 2))
) AS concat_name

-- Distinct is optional
GROUP_CONCAT(DISTINCT tb1.column1 ORDER BY tb1.column1 ASC SEPARATOR ',') AS concat_column1,

-- Splits the tb1.score column into 100 bins, and assign which bin it belongs to
NTILE(100) OVER (PARTITION BYB tb1.category ORDER BY tb1.score DESC) AS percentile

-- When doing a function in the context of a window function, then likewise need a window for it
COUNT(t1.id_1) OVER (PARTITION BY t1.id_2) / MAX(t1.id_1) OVER () * 100 AS ratio

FROM
your_table1 t1
-- INNER JOIN/ CROSS JOIN/ LEFT/ RIGHT
JOIN
your_table2 t2 
ON 
t1.common_key = t2.common_key AND
t1.date_key BETWEEN t2.start_date AND t2.end_date
WHERE
t1.some_column IS NOT NULL OR
-- % represents 0>= characters, _ represents 1 strictly
t1.some_column LIKE '% SAM%' AND 
-- Use REGEXP for regex pattern instead
conditions LIKE 'SAM%'
GROUP BY
column_alias1, t2.column2
-- WHERE: Can use both non-agg and agg functions inside
-- However if there is an agg function followed by group by
-- Use HAVING instead, which must use an agg function column
-- However if in select clause we used a window function to agg, then you cannot use that column
-- in both WHERE and HAVING, must use CTE
HAVING
COUNT(t1.column1) >= 5 
ORDER BY
days_difference DESC
LIMIT
10;


-- UNION of Categories
-- UNION keeps unique rows, UNION ALL keeps duplicates
(SELECT 'Low Salary' AS category)
UNION
(SELECT 'Average Salary')
UNION
(SELECT 'High Salary');


-- DELETE Rows with Criteria
-- DELETE rows from tb1 that meet the criteria below
DELETE tb1
FROM Person tb1
JOIN Person tb2
ON tb1.email = tb2.email AND tb1.id > tb2.id;


-- Select Second Highest Value with OFFSET
-- Then to ensure NULL if no value to offset, just wrap in select clause again
SELECT
(SELECT DISTINCT column1 
 FROM table1 
 ORDER BY column1 DESC 
 LIMIT 1 OFFSET 1) 
AS secondHighestValue;

-- LEARN CTE :)

-- ORDER BY can have aggregation based on the above group by 
SELECT col1
FROM tb1
GROUP BY col1
ORDER BY MAX(LENGTH(col2)) DESC
LIMIT 1