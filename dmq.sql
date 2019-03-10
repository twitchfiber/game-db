-- CS 340 Project: Joel Huffman (huffmajo), Frank Li (lifr)
-- Data Manipulation Queries - game-db project

----------------------------------------- SELECT QUERIES ----------------------------------------------------------
-- lists the top 10 highest rated games in the database
SELECT title, metacritic_score, release_date FROM game
ORDER BY metacritic_score DESC
LIMIT 10;

-- *changed p.id to p.plat_id to match DDL
-- find the platform of a game entered by user - search function
SELECT g.title AS game_title, p.name AS platform_name FROM game g INNER JOIN
game_plat gp ON (g.game_id = gp.game_id) INNER JOIN
platform p ON (gp.plat_id = p.plat_id) WHERE g.title = :name_of_game_entered_by_user;

-- display all games in database
SELECT g.title AS game_title, d.name AS developer_name, p.name AS publisher_name,
gen.name AS genre_name, g.release_date, g.metacritic_score FROM game g 
INNER JOIN publisher p ON (g.publisher = p.pub_id)
INNER JOIN developer d ON (g.developer = d.dev_id)
INNER JOIN genre gen ON (g.genre = gen.genre_id);

-- ***For Search by Genre function
-- *augmented to get string names rather than genre_ids
-- get all genres possible to populate a dropdown
SELECT name FROM genre;

-- *agumented to use string names from dropdown rather than genre_ids
-- use dropdown genre result chosen by user to display all games under that genre
SELECT g.title AS game_title, d.name AS developer_name, p.name AS publisher_name,
gen.name AS genre_name, g.release_date, g.metacritic_score FROM game g 
INNER JOIN publisher p ON (g.publisher = p.pub_id)
INNER JOIN developer d ON (g.developer = d.dev_id)
INNER JOIN genre gen ON (g.genre = gen.genre_id)
WHERE gen.name = :genre_chosen_from_dropdown;


-- ***For Search by Publisher function
-- get all publishers possible to populate dropdown
SELECT name FROM publisher;

-- use user-chosen publisher dropdown result to display all games by that publisher
SELECT g.title AS game_title, d.name AS developer_name, p.name AS publisher_name,
gen.name AS genre_name, g.release_date, g.metacritic_score FROM game g 
INNER JOIN publisher p ON (g.publisher = p.pub_id)
INNER JOIN developer d ON (g.developer = d.dev_id)
INNER JOIN genre gen ON (g.genre = gen.genre_id)
WHERE p.name = :publisher_chosen_from_dropdown;


-- ***For Search by Developer function
-- get all developers possible to populate dropdown
SELECT name FROM developer;

-- use user-chosen developer dropdown result to display all games by that developer
SELECT g.title AS game_title, d.name AS developer_name, p.name AS publisher_name,
gen.name AS genre_name, g.metacritic_score, g.release_date FROM game g 
INNER JOIN publisher p ON (g.publisher = p.pub_id)
INNER JOIN developer d ON (g.developer = d.dev_id)
INNER JOIN genre gen ON (g.genre = gen.genre_id)
WHERE d.name = :developer_chosen_from_dropdown;


-- ***For Search by Platform function
-- get all platforms possible to populate dropdown
SELECT name FROM platform;

-- use user-chosen platform dropdown result to display all games on that platform
SELECT g.title AS game_title, d.name AS developer_name, p.name AS publisher_name,
gen.name AS genre_name, g.release_date, g.metacritic_score FROM game g 
INNER JOIN publisher p ON (p.pub_id = g.publisher)
INNER JOIN developer d ON (d.dev_id = g.developer)
INNER JOIN genre gen ON (gen.genre_id = g.genre)
INNER JOIN game_plat gp ON (gp.game_id = g.game_id)
INNER JOIN platform pl ON (pl.plat_id = gp.plat_id)
WHERE pl.name = :platform_chosen_from_dropdown;


----------------------------------------- INSERT QUERIES ----------------------------------------------------------
-- insert game entity
INSERT INTO game (title, developer, publisher, release_date, metacritic_score, genre) VALUES
(:titleInput, :developerInput, :publisherInput, :releaseDateInput, :metacriticScoreInput, :genreInput);


-- insertion statements that populate dropdowns that are needed for game entries
    -- insert into pub
    INSERT INTO publisher (name) VALUES (:name_given_by_user);

    -- insert into dev
    INSERT INTO developer (name) VALUES (:developer_given_by_user);

    -- insert into platform
    INSERT INTO genre (name) VALUES (:genre_given_by_user);

    -- insert into genre
    INSERT INTO platform (name) VALUES (:platform_given_by_user);

-- associate game_id with a plat_id, if we don't associate then plat_id should be NULL in game_plat
INSERT INTO game_plat (game_id, plat_id) VALUES (:game_dropdown, :plat_dropdown)




-- UPDATE QUERIES ----------------------------------------------------------
UPDATE game SET title = :newTitle, :metacriticScoreInput, release_date = :releaseDateInput; genre = :genre_chosen_from_dropdown,
developer = developer_from_dropdown, publisher = platform_from_dropdown WHERE title = :title_from_dropdown;



-----------------------------------------DELETE QUERIES ----------------------------------------------------------
-- remove relationships M:M
DELETE FROM game_plat WHERE game_id = :game_dropdown AND plat_id = :plat_choices;