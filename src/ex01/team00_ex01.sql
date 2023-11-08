SELECT *
FROM v_trips
WHERE total_cost = (SELECT MIN(total_cost) FROM v_trips)
UNION ALL
SELECT *
FROM v_trips
WHERE total_cost = (SELECT MAX(total_cost) FROM v_trips)
ORDER BY total_cost, tour;
