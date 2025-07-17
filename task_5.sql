/*добавьте сюда запрос для решения задания 5*/

WITH raw_menu AS (
  SELECT
    r.name AS "Название заведения",
    r.menu -> 'Пицца' AS pizza_menu
  FROM cafe.restaurants r
  WHERE r.type = 'pizzeria'
),
flattened_menu AS (
  SELECT
    "Название заведения",
    item.key AS "Название пиццы",
    item.value::int AS "Цена",
    'Пицца' AS "Тип блюда"
  FROM raw_menu,
       LATERAL json_each_text(pizza_menu::json) AS item
),
ranked_menu AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY "Название заведения"
           ORDER BY "Цена" DESC
         ) AS rn
  FROM flattened_menu
)
SELECT
  "Название заведения",
  "Тип блюда",
  "Название пиццы",
  "Цена"
FROM ranked_menu
WHERE rn = 1
ORDER BY "Название заведения";