/*добавьте сюда запросы для решения задания 7*/

BEGIN;

LOCK TABLE cafe.managers IN SHARE ROW EXCLUSIVE MODE;

ALTER TABLE cafe.managers ADD COLUMN IF NOT EXISTS phone_numbers TEXT[];

WITH ordered_managers AS (
    SELECT
        manager_uuid,
        phone,
        ROW_NUMBER() OVER (ORDER BY name) + 99 AS rn
    FROM cafe.managers
)
UPDATE cafe.managers m
SET phone_numbers = ARRAY[
    CONCAT('8-800-2500-', LPAD(om.rn::TEXT, 3, '0')),
    m.phone
]
FROM ordered_managers om
WHERE m.manager_uuid = om.manager_uuid;

ALTER TABLE cafe.managers DROP COLUMN phone;

COMMIT;
