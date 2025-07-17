/*добавьте сюда запрос для решения задания 3*/

SELECT
    r.name AS restaurant_name,
    COUNT(*) AS manager_change_count
FROM cafe.restaurant_manager_work_dates rw
JOIN cafe.restaurants r ON r.restaurant_uuid = rw.restaurant_uuid
GROUP BY r.name
ORDER BY manager_change_count DESC
LIMIT 3;
