-- SQL Workshop September 20


-- Find all movie-names that have the word "Car" as the first word in the name.


SELECT name FROM movies WHERE name LIKE 'Car %';



-- Find all movies made in the year you were born.


SELECT * FROM movies WHERE year = 1990;



-- Find actors who have "stack" in their last name.

SELECT first_name || ' ' || last_name FROM actors WHERE last_name LIKE '%stack%';




-- How many movies does our dataset have for the year 1982?

SELECT SUM(first_name) FROM actors WHERE *




-- Find actors who have "stack" in their last name.


SELECT COUNT(name) FROM movies WHERE year=1982;



-- What are the 10 most popular first names and last names in the business? 

SELECT first_name, COUNT(first_name) FROM actors GROUP BY first_name ORDER BY COUNT(first_name) DESC LIMIT 10;



-- And how many actors have each given first or last name? This can be multiple queries.


SELECT first_name, COUNT(first_name) FROM actors GROUP BY first_name ORDER BY COUNT(first_name) DESC LIMIT 10;







--Get count of all actors from Actors table from USA



count(*) FROM Actors WHERE country='USA';









-- List the top 100 most active actors and the number of roles they have starred in.
SELECT 'FirstName' AS first_name, 'LastName' AS last_name, 'Number of Movies' AS roles.actor_id
UNION ALL

-- an attempt to set column headers
SELECT first_name, last_name, COUNT(roles.actor_id)
FROM actors
JOIN roles ON actors.id = roles.actor_id
GROUP BY roles.actor_id
ORDER BY COUNT(roles.actor_id)
DESC LIMIT 100;

-- How many movies does IMDB have of each genre, ordered by least popular genre?

SELECT genre, COUNT(genre) 
FROM movies_genres
GROUP BY genre
ORDER BY COUNT(genre) ASC
LIMIT 100;


-- How many movies does IMDB have of each genre, ordered by least popular genre?



SELECT genre, COUNT(genre) 

FROM movies_genres

GROUP BY genre

ORDER BY COUNT(genre) ASC

LIMIT 100;



-- List the first and last names of all the actors who played in the 1995 movie 'Braveheart', arranged alphabetically by last name.

-- CREATE TABLE "actors" (
--   "id" int(11) NOT NULL DEFAULT '0',
--   "first_name" varchar(100) DEFAULT NULL,
--   "last_name" varchar(100) DEFAULT NULL,
--   "gender" char(1) DEFAULT NULL,
--   PRIMARY KEY ("id")
-- );
-- CREATE INDEX "actors_idx_first_name" ON "actors" ("first_name");
-- CREATE INDEX "actors_idx_last_name" ON "actors" ("last_name");
-- sqlite> .schema movies
-- CREATE TABLE "movies" (
--   "id" int(11) NOT NULL DEFAULT '0',
--   "name" varchar(100) DEFAULT NULL,
--   "year" int(11) DEFAULT NULL,
--   "rank" float DEFAULT NULL,
--   PRIMARY KEY ("id")
-- );


SELECT first_name, last_name
FROM actors JOIN roles
ON actors.id = roles.actor_id
JOIN movies
ON movies.id = roles.movie_id
WHERE movies.name = 'Braveheart' AND movies.year = '1995'
ORDER BY actors.last_name;






-- List all the directors who directed a 'Film-Noir'-genre movie in a leap year 

-- (for the sake of this challenge, pretend that all years divisible by 4 are leap years — 

-- which is not true in real life). Your query should return director name, the movie name,

-- and the year, sorted by movie name.



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

-- List all the actors that have worked with Kevin Bacon in Drama movies (include the movie name ) Please exclude Mr Bacon huimself from the result.

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

-- Subquery
-- http://www.dofactory.com/sql/subquery

-- Which actors have acted in a film before 1900 and also in a film after 2000? 
-- NOTE: we are not asking you for all the pre-1900 and post-2000 actors — 
-- we are asking for each actor who worked in both eras!


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
-- DISTINT on roles

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


