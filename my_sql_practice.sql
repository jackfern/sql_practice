-- Of the smallest 10 countries, which has the biggest gnp? (hint: use with and max)

WITH biggest_gnp A

(SELECT
	name,
	surfacearea,
	gnp,
	population/surfacearea AS population_density
FROM
	countries
WHERE
	population > 0

ORDER BY
	population_density ASC
LIMIT
	10)

SELECT
	MAX (gnp),
	name
FROM
	biggest_gnp
GROUP BY
	biggest_gnp.name
ORDER BY
	MAX (gnp) DESC
LIMIT
	10;





	WITH SURFACE_AREA AS
(SELECT
	name,
	surfacearea,
	governmentform
FROM
	countries
ORDER BY
	surfacearea DESC
LIMIT
	10)

	What are the forms of government for the top ten countries by surface area?

SELECT
	name,
	governmentform
FROM
	SURFACE_AREA

GROUP BY
	surface_area.governmentform,
	SURFACE_AREA.name;
