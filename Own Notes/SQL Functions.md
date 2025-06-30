# Advanced SQL Patterns Cheat Sheet

---

## Basic Aggregation and Cleaning

```sql
SELECT
    COUNT(DISTINCT t1.column) AS row_count,
    LENGTH(t1.column) AS num_items,                        -- string: character count; JSON: item count
    COALESCE(t1.column, 0) AS no_null_column,              -- returns first non-null value
```

## Conditional Aggregation

```sql
    IF(
        t1.date_column IS NULL,
        0,
        DATEDIFF(NOW(), t1.date_column)                   -- days since date_column
    ) AS days_difference,
```

## Date Formatting

```sql
    DATE_FORMAT(t1.dates, '%Y-%m') AS month_date,
```

## LEAST / GREATEST

```sql
SELECT LEAST(3, 12, 34, 8, 25);
```

---

## Window Functions

```sql
    SUM(t1.column) OVER (ORDER BY t1.id) AS cumulative_sum,
    LAG(t1.column, 1) OVER (ORDER BY t1.id) AS column_next_value,
    DENSE_RANK() OVER (PARTITION BY t1.id ORDER BY t1.column1 ASC) AS ranking,
    PERCENT_RANK() OVER (PARTITION BY tb1.category ORDER BY tb1.score DESC) AS percentile,
    COUNT(t1.id_1) OVER (PARTITION BY t1.id_2) / MAX(t1.id_1) OVER () * 100 AS ratio,
```

---

## Conditional Columns (CASE)

```sql
    CASE
        WHEN t1.column2 < 3 THEN 1
        ELSE 0
    END AS indicator_column,
```

---

## Math Operations

```sql
    t1.column MOD 7 AS modulo_remainder,
    t1.column DIV 7 AS integer_division,
```

---

## String Manipulation

```sql
    CONCAT(
        UPPER(SUBSTRING(t1.name, 1, 1)),
        LOWER(SUBSTRING(t1.name, 2))
    ) AS concat_name,
```

---

## Group Concatenation

```sql
    GROUP_CONCAT(
        DISTINCT tb1.column1
        ORDER BY tb1.column1 ASC
        SEPARATOR ','
    ) AS concat_column1
```

---

## Example FROM and JOIN

```sql
FROM
    your_table1 t1
JOIN
    your_table2 t2
    ON t1.common_key = t2.common_key
    AND t1.date_key BETWEEN t2.start_date AND t2.end_date
```

---

## Filtering and Pattern Matching

* `%` → zero or more characters
* `_` → exactly one character
* `\\b` → word boundary (use in regex)

```sql
WHERE
    t1.some_column IS NOT NULL OR
    t1.some_column LIKE '%SAM%' AND
    conditions LIKE 'SAM%'
```

---

## GROUP BY, HAVING, ORDER BY, LIMIT

* Use `HAVING` for aggregate filters after `GROUP BY`.
* Window function columns cannot be directly used in `WHERE`/`HAVING` → use CTEs instead.

```sql
GROUP BY
    column_alias1, t2.column2

HAVING
    COUNT(t1.column1) >= 5

ORDER BY
    days_difference DESC

LIMIT
    10;
```

---

## UNION (Unique) vs UNION ALL (Keep Duplicates)

```sql
(SELECT 'Low Salary' AS category)
UNION
(SELECT 'Average Salary')
UNION
(SELECT 'High Salary');
```

---

## DELETE with JOIN

Delete duplicates while keeping the lower ID:

```sql
DELETE tb1
FROM Person tb1
JOIN Person tb2
    ON tb1.email = tb2.email
    AND tb1.id > tb2.id;
```

---

## Select the Second Highest Value with OFFSET

```sql
SELECT
(
    SELECT DISTINCT column1
    FROM table1
    ORDER BY column1 DESC
    LIMIT 1 OFFSET 1
) AS secondHighestValue;
```

---

## ORDER BY with Aggregation

```sql
SELECT col1
FROM tb1
GROUP BY col1
ORDER BY MAX(LENGTH(col2)) DESC
LIMIT 1;
```

---

## Additional Notes

✅ Use **`SUM(IF(...))`** for conditional aggregation.
✅ Use **window functions** for partitioned rolling calculations.
✅ For advanced ETL, combine **CTEs** with **window functions** for clarity.
✅ Use **`REGEXP`** for regex-based filtering for advanced pattern matching.
