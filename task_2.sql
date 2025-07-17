/*добавьте сюда запрос для решения задания 2*/

CREATE MATERIALIZED VIEW cafe.avg_check_yearly_trend AS
WITH yearly_avg AS (
    SELECT
        EXTRACT(YEAR FROM s.date)::INT AS year,
        r.name AS restaurant_name,
        r.type AS restaurant_type,
        ROUND(AVG(s.avg_check), 2) AS avg_check
    FROM cafe.sales s
    JOIN cafe.restaurants r ON r.restaurant_uuid = s.restaurant_uuid
    WHERE EXTRACT(YEAR FROM s.date)::INT <> 2023
    GROUP BY year, r.name, r.type
),
with_lag AS (
    SELECT
        year,
        restaurant_name,
        restaurant_type,
        avg_check AS avg_check_current,
        LAG(avg_check) OVER (
            PARTITION BY restaurant_name
            ORDER BY year
        ) AS avg_check_previous
    FROM yearly_avg
)
SELECT
    year,
    restaurant_name,
    restaurant_type,
    avg_check_current,
    avg_check_previous,
    ROUND(
        CASE
            WHEN avg_check_previous IS NOT NULL AND avg_check_previous <> 0
                THEN ((avg_check_current - avg_check_previous) / avg_check_previous) * 100
            ELSE NULL
        END,
        2
    ) AS avg_check_change_percent
FROM with_lag;
