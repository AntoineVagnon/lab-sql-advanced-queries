#List each pair of actors that have worked together.

SELECT
	fa1.actor_id,
    fa2.actor_id
FROM film_actor fa1
JOIN film_actor fa2 ON fa1.film_id = fa2.film_id
AND fa1.actor_id != fa2.actor_id
WHERE fa1.actor_id < fa2.actor_id;

#For each film, list actor that has acted in more films.

WITH CTE AS (
    SELECT 
	    fa1.film_id, 
	    fa1.actor_id as "Actor", 
	    CountTable.count as "Count",
        ROW_NUMBER() OVER(PARTITION BY fa1.film_id ORDER BY CountTable.count DESC) as row_num
    FROM 
	    film_actor fa1
    JOIN
	    (SELECT 
		    fa2.actor_id, 
		    COUNT(*) as count
	    FROM 
		    film_actor fa2
	    GROUP BY 
		    fa2.actor_id) AS CountTable
    ON 
	    fa1.actor_id = CountTable.actor_id
)
SELECT 
    film_id,
    Actor,
    Count
FROM 
    CTE
WHERE 
    row_num = 1;
