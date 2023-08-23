-- Day 3
-- ex 07
INSERT INTO menu
VALUES (19, 2, 'greek pizza', 800);

-- ex 08
INSERT INTO menu
VALUES
(
    (SELECT max(id) + 1 FROM menu),
    (SELECT id FROM pizzeria WHERE name = 'Dominos'),
    'sicilian pizza',
    900
);

-- ex 09
INSERT INTO person_visits
VALUES
(
    (SELECT max(id) + 1 FROM person_visits),
    (SELECT id FROM person WHERE name = 'Denis'),
    (SELECT id FROM pizzeria WHERE name = 'Dominos'),
    '2022-02-24'
 ),
(
    (SELECT max(id) + 2 FROM person_visits),
    (SELECT id FROM person WHERE name = 'Irina'),
    (SELECT id FROM pizzeria WHERE name = 'Dominos'),
    '2022-02-24'
);

-- ex 10
INSERT INTO person_order
VALUES
(
    (SELECT MAX(id) + 1 FROM person_order),
    (SELECT id FROM person WHERE name = 'Denis'),
    (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza'),
    '2022-02-24'
),
(
    (SELECT MAX(id) + 2 FROM person_order),
    (SELECT id FROM person WHERE name = 'Irina'),
    (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza'),
    '2022-02-24'
);

-- ex 11
UPDATE menu
SET price = (price * 0.9)
WHERE pizza_name = 'greek pizza';

-- ex 12
INSERT INTO person_order
SELECT
    gp,
    p.id,
    (SELECT id FROM menu WHERE pizza_name = 'greek pizza'),
    '2022-02-25'
FROM
    generate_series(
        (SELECT MAX(id) + 1 FROM person_order),
        ((SELECT MAX(id) + 1 FROM person_order) + (SELECT MAX(id) FROM person)), 1
        ) AS gp
    JOIN person p ON gp = p.id + (SELECT MAX(id) FROM person_order);

-- ex 13
DELETE FROM person_order
WHERE order_date = '2022-02-25';
DELETE FROM menu
WHERE pizza_name = 'greek pizza';

-- Day 4
-- ex 06 (без него 07 не работает)
CREATE MATERIALIZED VIEW mv_dmitriy_visits_and_eats AS
SELECT
    pizzeria.name AS pizzeria_name
FROM
    pizzeria
    RIGHT JOIN menu m on pizzeria.id = m.pizzeria_id
    LEFT JOIN person_visits pv on pizzeria.id = pv.pizzeria_id
    JOIN person p on p.id = pv.person_id
WHERE
    p.name = 'Dmitriy' AND
    pv.visit_date = '2022-01-08' AND
    price < 800;

-- ex 07
INSERT INTO person_visits
VALUES
(
    (SELECT max(id) + 1 FROM person_visits),
    (SELECT id FROM person WHERE name = 'Dmitriy'),
    (SELECT DISTINCT
        p.id
    FROM
        menu m
        JOIN pizzeria p on p.id = m.pizzeria_id
    WHERE
        m.price < 800
        AND p.name NOT IN
        (SELECT * FROM mv_dmitriy_visits_and_eats)
    LIMIT 1
    ),
    '2022-01-08'
);

REFRESH MATERIALIZED VIEW mv_dmitriy_visits_and_eats
