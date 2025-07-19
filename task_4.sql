/*добавьте сюда запрос для решения задания 4*/

WITH pizzas_count AS (
  SELECT
    r.name AS "Название заведения",
    COUNT(*) AS "Количество пицц в меню"
  FROM
    cafe.restaurants r,
    LATERAL jsonb_each(r.menu->'Пицца') AS pizza
  WHERE
    r.type = 'pizzeria' AND r.menu ? 'Пицца'
  GROUP BY
    r.name
),
ranked_pizzas AS (
  SELECT
    "Название заведения",
    "Количество пицц в меню",
    DENSE_RANK() OVER (ORDER BY "Количество пицц в меню" DESC) AS rank
  FROM pizzas_count
)
SELECT
  "Название заведения",
  "Количество пицц в меню"
FROM
  ranked_pizzas
WHERE
  rank = 1;
