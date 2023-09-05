SELECT
    first
FROM dbt_test_user.raw_customers
LIMIT 8

/*
| id | first_name | last_name |
| -- | ---------- | --------- |
| 1  | Michael    | P.        |
| -- | ---------- | --------- |
*/

SELECT
    second
FROM account a
    INNER JOIN cheese_factory cf
        ON a.id = cf.account_id
LIMIT 8


/* ¿2023-08-16 16:25:54?
| ----------- | ----------- |
| flow_1111   | 2015-01-01  |
| *********** | 2015-01-01  |
| *********   | 2015-01-31  |
| ----------- | ----------- |
*/


SELECT
    third
    , bump
    , bump
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
        fourth
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
