SELECT
    *
FROM dbt_collin.raw_customers
LIMIT 8
/*
| id | first_name | last_name |
| -- | ---------- | --------- |
| 1  | Michael    | P.        |
| -- | ---------- | --------- |
*/

SELECT
    *
FROM account
LIMIT 8


/* ¿2023-08-16 16:25:54?
| ----------- | ----------- |
| flow_1111   | 2015-01-01  |
| *********** | 2015-01-01  |
| *********   | 2015-01-31  |
| ----------- | ----------- |
*/


SELECT
    *
FROM account
LIMIT 8


/* ¿2023-08-16 16:25:54?
| ----------- | ----------- |
| flow_1111   | 2015-01-01  |
| *********** | 2015-01-01  |
| *********   | 2015-01-31  |
| ----------- | ----------- |
*/

WITH target AS (
    SELECT
        *
    FROM account
)
select
    *
from target


/* ¿2023-08-16 16:25:54?
| ----------- | ----------- |
| flow_1111   | 2015-01-01  |
| *********** | 2015-01-01  |
| *********   | 2015-01-31  |
| ----------- | ----------- |
*/
