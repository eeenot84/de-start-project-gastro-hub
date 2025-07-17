/*добавьте сюда запрос для решения задания 1*/

CREATE OR REPLACE VIEW cafe.top3_restaurants_by_avg_check AS
WITH avg_checks AS (
    SELECT
        s.restaurant_uuid,
        ROUND(AVG(s.avg_check), 2) AS avg_check
    FROM cafe.sales s
    GROUP BY s.restaurant_uuid
),
ranked_restaurants AS (
    SELECT
        r.name AS restaurant_name,
        r.type AS restaurant_type,
        a.avg_check,
        ROW_NUMBER() OVER (
            PARTITION BY r.type
            ORDER BY a.avg_check DESC
        ) AS rank
    FROM avg_checks a
    JOIN cafe.restaurants r ON r.restaurant_uuid = a.restaurant_uuid
)
SELECT
    restaurant_name,
    restaurant_type,
    avg_check
FROM ranked_restaurants
WHERE rank <= 3;
