-- SQL Workshop September 20


-- Find all movie-names that have the word "Car" as the first word in the name.


SELECT name FROM movies WHERE name LIKE 'Car %';



-- Find all movies made in the year you were born.


SELECT * FROM movies WHERE year = 1990;




-- How many movies does our dataset have for the year 1982?

SELECT SUM(first_name) FROM actors WHERE *



-- Find actors who have "stack" in their last name.

SELECT * FROM actors WHERE last_name LIKE '%stack%';


-- What are the 10 most popular first names and last names in the business? 

SELECT first_name, COUNT(*) as occurences
FROM actors
GROUP BY first_name
ORDER BY COUNT occurences DESC
LIMIT 10;

SELECT last_name, COUNT(*) as occurences
FROM actors
GROUP BY first_name
ORDER BY COUNT occurences DESC
LIMIT 10;



-- And how many actors have each given first or last name? This can be multiple queries.

SELECT first_name, last_name, COUNT(*) as num_roles
FROM actors
INNER JOIN roles ON actors.id = roles.actor_id
GROUP BY actors.id
RDER BY num_roles DESC
LIMIT 100;

-- Bottom of the Barrel
-- How many movies does IMDB have of each genre, ordered by least popular genre?

SELECT genre, COUNT(*) as num_movies 
FROM movies_genres
GROUP BY genre
ORDER BY num_movies ASC
LIMIT 100;




--Get count of all actors from Actors table from USA



count(*) FROM Actors WHERE country='USA';


-- List the top 100 most active actors and the number of roles they have starred in.

SELECT 'FirstName' AS first_name, 'LastName' AS last_name, 'Number of Movies' AS roles.actor_id
UNION ALL

-- an attempt to set column headers
SELECT first_name, last_name, roles.role
FROM actors
INNER JOIN roles ON actors.id = roles.actor_id
GROUP BY roles.actor_id
COUNT(roles.actor_id)
JOIN roles ON actors.id = roles.actor_id

ORDER BY COUNT(roles.actor_id)
DESC LIMIT 100;




-- How many movies does IMDB have of each genre, ordered by least popular genre?



SELECT genre, COUNT(genre) 

FROM movies_genres

GROUP BY genre

ORDER BY COUNT(genre) ASC

LIMIT 100;



-- List the first and last names of all the actors who played in the 1995 movie 'Braveheart', arranged alphabetically by last name.


SELECT first_name, last_name
FROM actors 
INNER JOIN roles ON actors.id = roles.actor_id
INNER JOIN movies ON movies.id = roles.movie_id
	AND movies.name = 'Braveheart'
	AND movies.year = '1995'
ORDER BY actors.last_name;


-- List all the directors who directed a 'Film-Noir'-genre movie in a leap year 
-- (for the sake of this challenge, pretend that all years divisible by 4 are leap years — 
-- which is not true in real life). Your query should return director name, the movie name,
-- and the year, sorted by movie name.

--SUGGESTED SOLUTION:

SELECT *
FROM movies AS m
	INNER JOIN movies_genres AS mg
	  ON m.id = mg.movie_id
	  AND mg.genre = 'Film-Noir'
	    INNER JOIN movies_directors AS md ON m.id= md.movie_id
	      INNER JOIN directors AS d On md.director_id = d.i
WHERE  year % 4 = 0
ORDER BY m.name ASC;

-- OUR SOLUTION:
SELECT first_name, last_name, movies.year
FROM directors
JOIN movies_directors
ON directors.id = movies_directors.director_id
JOIN movies_genres
ON movies_directors.movie_id = movies_genres.movie_id
JOIN movies
ON movies.id = movies_genres.movie_id
WHERE movies_genres.genre = 'Film-Noir'
AND movies.year % 4 = 0;

-- List all the actors that have worked with Kevin Bacon
--in Drama movies (include the movie name ) Please exclude Mr Bacon huimself from the result.

--Suggested Solution:

SELECT a.first_name || " " || a.last_name AS full_name, m.name
FROM actors AS a
INNER JOIN roles AS r On r.actor_id=a.id
INNER JOIN movies AS m ON r.movie_id = m.id
INNER JOIN movies_genres AS mg
ON mg.movie_id = m.id
AND mg.genre = 'Drama'
WHERE m.id IN (
SELECT m2.id
FROM movies AS m2
INNER JOIN roles AS r2 ON r2.movie_id = m2.id
INNER JOIN actors AS a2
ON r2.actor_id = a2.id
AND a2.first_name = 'Kevin'
AND a2.last_name = 'Bacon'
)
AND full_name != 'Kevin Bacon'
ORDER BY a.last_name ASC;


--Our Solution
SELECT movies.name, first_name, last_name
FROM actors
JOIN roles
ON actors.id = roles.actor_id
JOIN movies
ON movies.id = roles.movie_id
WHERE movies.name IN 
	(SELECT movies.name
	FROM roles 
	JOIN movies_genres
	ON movies_genres.movie_id = roles.movie_id
	JOIN movies
	ON movies.id = movies_genres.movie_id
	WHERE movies_genres.genre = 'Drama' AND roles.actor_id = '22591')
	AND actors.id <> '22591';

-- Subquery Outline
-- http://www.dofactory.com/sql/subquery

-- THE IMMORTALS:
-- Which actors have acted in a film before 1900 and also in a film after 2000? 
-- NOTE: we are not asking you for all the pre-1900 and post-2000 actors — 
-- we are asking for each actor who worked in both eras!

-- SUGGESTED SOLUTION:
SELECT actors.id, actors.first_name, actors.last_name
FROM actors
	INNER JOIN roles ON roles.actor_id = actors.id
	INNER JOIN movies on movies.ID = roles.movie_id
WHERE movies.year < 1900
INTERSECT
SELECT actors.id, actors.first_name, actors.last_name
FROM actors
	INNER JOIN roles ON roles.actor_id = actors.id
	INNER JOIN movies on movies.ID = roles.movie_id
WHERE movies.year > 2000;


--OUR SOLUTION:
SELECT first_name, last_name
FROM actors
WHERE actors.id IN
(SELECT actors.id
FROM actors
JOIN roles
ON actors.id = roles.actor_id
JOIN movies
ON movies.id = roles.movie_id
WHERE movies.year < 1900)
AND actors.id IN
(SELECT actors.id
FROM actors
JOIN roles
ON actors.id = roles.actor_id
JOIN movies
ON movies.id = roles.movie_id
WHERE movies.year > 2000);



-- Find actors that played five or more roles in the same movie after the year 1990. 
-- Notice that ROLES may have occasional duplicates, but we are not interested in these: 
-- we want actors that had five or more distinct (cough cough) roles in the same movie. 
-- Write a query that returns the actors' names, the movie name, and the number of distinct 
-- roles that they played in that movie (which will be ≥ 5).

-- group the movies and roles
-- results GROUP BY movies
-- DISTINCT on roles (cough cough)

--SUGGESTED SOLUTION:

SELECT COUNT(DISTINCT roles.role) as num_role_in_movies, *
FROM actors
INNER JOIN roles ON roles.actor_id = actors.id
INNER JOIN movies ON roles.movie_id = movies.id
WHERE movies.year > 1990
GROUP BY actors.id, movies.id
HAVING num_role_in_movies > 4;


--OUR SOLUTION:

SELECT first_name, last_name, movies.name, movies.year, COUNT(DISTINCT roles.role) AS num_roles
FROM actors
JOIN roles
ON actors.id = roles.actor_id
JOIN movies
ON movies.id = roles.movie_id
WHERE movies.year > 1990
GROUP BY movie_id, actor_id
HAVING num_roles > 4
ORDER BY num_roles DESC;

--FEMALE ACTORS ONLY
--For each year, count the numbe of movies that had only female actors

--SUGGESTED SOLUTION:

SELECT *
FROM movies
WHERE movies.id NOT IN (
	SELECT DISTINCT movies.id
	FROM movies
	INNER JOIN roles ON movies.id = roles.movie_id
	INNER JOIN actors
		ON roles.actor_id = actors.id
		AND actors.gender = 'M'
);
