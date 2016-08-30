--What languages are spoken in the 20 poorest (GNP/ capita) countries in the world? Hint: Use DISTINCT to remove duplicates

WITH poorest_countries AS

(SELECT
	name,
	population,
	gnp,
	gnp / population AS gnp_per_capita
FROM
	countries

WHERE
	population > 0 AND
	gnp > 0

ORDER BY
	gnp_per_capita ASC
LIMIT
	20)


SELECT
  *
FROM
  poorest_countries,
  public.countrylanguages,
  public.countries
WHERE
  countrylanguages.countrycode = countries.code

Limit
	20;

--Are there any countries without an official language?

SELECT DISTINCT
  countries.name,
  isofficial
FROM
	public.countries,
	public.countrylanguages
WHERE
	countrylanguages.countrycode = countries.code AND
	countrylanguages.countrycode NOT IN

(SELECT
	countrycode
FROM
        public.countrylanguages

WHERE
	isofficial = true);




	-- Which languages are spoken in the ten largest (area) countries?


	SELECT
  *
FROM
  public.countries,
  public.countrylanguages
WHERE
  countries.code = countrylanguages.countrycode;


	-- What are the cities in the countries with no official language?

	SELECT DISTINCT
		cities.name,
		isofficial,
		countries.name,
		languages
	FROM
	  public.cities,
	  public.countries,
	  public.countrylanguages
	WHERE
	  cities.countrycode = countries.code AND
	  countries.code = countrylanguages.countrycode AND
	  countrylanguages.countrycode = cities.countrycode AND
	  countrylanguages.countrycode NOT IN

	 (SELECT
		countrycode
	FROM
	        public.countrylanguages

	WHERE
		isofficial = true);

		--Which countries have the highest proportion of official language speakers? The lowest?

		SELECT DISTINCT
	cities.name,
	isofficial,
	countries.name,
	percentage

FROM
	public.cities,
	public.countries,
	public.countrylanguages
WHERE
	cities.countrycode = countries.code AND
	countries.code = countrylanguages.countrycode AND
	countrylanguages.countrycode = cities.countrycode AND
	countrylanguages.countrycode NOT IN

 (SELECT
	countrycode
FROM
				public.countrylanguages

WHERE
	isofficial = true)

ORDER BY
	countrylanguages.percentage ASC;

--What is the most spoken language in the world?

SELECT
  name,
  population,
  language,
  percentage
FROM
  public.countries,
  public.countrylanguages
WHERE
  countries.code = countrylanguages.countrycode

ORDER BY
	population DESC;

--What is the population of the United States? What is the city population of the United States?


SELECT
	population,
	name
FROM
	public.countries
WHERE
	name = 'United States'


	WITH total_cities AS

	(SELECT
		cities.name,
		cities.population,
		cities.countrycode

	FROM
		public.cities

	WHERE
		cities.countrycode = 'USA')

	SELECT
		SUM(total_cities.population)
	FROM
		total_cities;

--How many countries have no cities?

SELECT DISTINCT
  cities.name
FROM
	public.countries,
	public.cities
WHERE
	cities.countrycode = countries.code; AND
	cities.countrycode NOT IN

(SELECT
	name
FROM
        public.cities

WHERE
	isofficial = true);

--in the cities table, the country code will not be there (answer = 7)

SELECT
	countries.code,
	countries.name
FROM
	public.countries

EXCEPT

(SELECT
	countries.code,
	countries.name
FROM
	public.countries,
	public.cities
WHERE
	countries.code = cities.countrycode);


--What is the total population of cities where English is the offical language? Spanish? Hint: The official language of a city is based on country.

WITH english_only AS

(SELECT
  cities.name,
  countrylanguages.language,
  countrylanguages.isofficial,
  cities.population

FROM
  public.cities,
  public.countries,
  public.countrylanguages
WHERE
  cities.countrycode = countrylanguages.countrycode AND
  countries.code = cities.countrycode AND
  countrylanguages.countrycode = countries.code AND
  countrylanguages.language = 'English' AND
  countrylanguages.isofficial = true)

SELECT
  SUM(english_only.population)
FROM
  english_only;

--Which countries have the 100 biggest cities in the world?

SELECT DISTINCT
  cities.population,
  cities.name,
  countries.name,
  countrylanguages.language
FROM
  public.cities,
  public.countries,
  public.countrylanguages
WHERE
  cities.countrycode = countries.code AND
  cities.countrycode = countrylanguages.countrycode AND
  countries.code = countrylanguages.countrycode
ORDER BY
	cities.population DESC
LIMIT
	100;









-- What are the categories of the movies that have never sold?

SELECT
	prod.*
FROM
	products prod
	LEFT OUTER JOIN
	orderlines ord ON(ord.prod_id = prod.prod_id)
WHERE
	ord.prod_id IS NULL
