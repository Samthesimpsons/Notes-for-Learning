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

## DATEDIFF vs TIMEDIFF

* `DATEDIFF(expr1, expr2)` → returns the number of **days** between two dates (ignores the time part).
* `TIMEDIFF(expr1, expr2)` → returns the difference as a **TIME value** (`HH:MM:SS`); both arguments must be the same type (TIME or DATETIME).
* Result is `expr1 - expr2`, so put the later value first for a positive result.
* Aggregation functions like `AVG` cannot run directly on a TIME value → convert with `TIME_TO_SEC` first, aggregate, then convert back with `SEC_TO_TIME`.

```sql
SELECT TIMEDIFF('2026-08-31 10:30:00', '2026-08-31 08:15:00');  -- returns '02:15:00'

SELECT
    TIMEDIFF(t1.end_time, t1.start_time) AS duration,
    TIME_TO_SEC(TIMEDIFF(t1.end_time, t1.start_time)) AS duration_seconds
FROM your_table1 t1;

SELECT
    SEC_TO_TIME(
        AVG(TIME_TO_SEC(TIMEDIFF(t1.end_time, t1.start_time)))
    ) AS avg_duration                                           -- aggregate in seconds, convert back
FROM your_table1 t1;
```

## LEAST / GREATEST vs MIN / MAX

* `LEAST` / `GREATEST` → **scalar** functions: compare values **across columns within a single row**.
* `MIN` / `MAX` → **aggregate** functions: compare values **down a single column across rows** (or per group with `GROUP BY`).
* `LEAST` / `GREATEST` return `NULL` if **any** argument is `NULL` (wrap with `COALESCE`); `MIN` / `MAX` simply ignore `NULL` rows.

```sql
SELECT LEAST(3, 12, 34, 8, 25);                            -- returns 3 (row-wise)

SELECT
    LEAST(t1.price_a, t1.price_b, t1.price_c) AS cheapest, -- per row, across columns
    GREATEST(t1.start_date, t2.start_date) AS overlap_start
FROM your_table1 t1
JOIN your_table2 t2 ON t1.id = t2.id;

SELECT
    MIN(t1.price_a) AS lowest_price,                       -- per column, across rows
    MAX(t1.price_a) AS highest_price
FROM your_table1 t1;
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
