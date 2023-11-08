CREATE TABLE nodes (
    point1 VARCHAR NOT NULL,
    point2 VARCHAR NOT NULL,
    cost INTEGER NOT NULL,
    UNIQUE(point1,point2) 
);

INSERT INTO nodes(point1,point2,cost)
VALUES  ('A', 'B', 10),
        ('B', 'A', 10),
        ('A', 'C', 15),
        ('C', 'A', 15),
        ('A', 'D', 20),
        ('D', 'A', 20),
        ('B', 'D', 25),
        ('D', 'B', 25),
        ('B', 'C', 35),
        ('C', 'B', 35),
        ('C', 'D', 30),
        ('D', 'C', 30);


CREATE VIEW v_trips(total_cost, tour) AS (
WITH RECURSIVE tour_way AS (
    SELECT point1 AS tour, point1, point2, nodes.cost, nodes.cost AS total_cost
    FROM nodes 
    WHERE point1 = 'A'
    UNION ALL
    SELECT concat(parrent.tour, ',', ch.point1) AS trace, ch.point1, ch.point2, ch.cost, (parrent.total_cost + ch.cost) AS total_cost
    FROM nodes AS ch
    JOIN tour_way AS parrent ON ch.point1 = parrent.point2 
    WHERE tour NOT LIKE concat('%', ch.point1, '%') 
)
SELECT total_cost, CONCAT('{', tour, ',', point2, '}') AS tour 
FROM tour_way
WHERE point2 = 'A' AND LENGTH(tour) = 7
ORDER BY total_cost);

SELECT *
FROM v_trips
WHERE total_cost = (SELECT MIN(total_cost) FROM v_trips)
ORDER BY total_cost, tour

