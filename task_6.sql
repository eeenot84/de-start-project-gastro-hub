/*добавьте сюда запросы для решения задания 6*/

BEGIN;

WITH updated_menus AS (
    SELECT
        restaurant_uuid,
        jsonb_set(
            menu,
            '{Кофе,Капучино}',
            to_jsonb((menu->'Кофе'->>'Капучино')::NUMERIC * 1.2),
            true
        ) AS new_menu
    FROM cafe.restaurants
    WHERE menu->'Кофе' ? 'Капучино'
    FOR UPDATE
)

UPDATE cafe.restaurants r
SET menu = u.new_menu
FROM updated_menus u
WHERE r.restaurant_uuid = u.restaurant_uuid;

COMMIT;
