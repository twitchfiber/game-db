-- Data Manipulation Queries - game-db project

----------------------------------------- SELECT QUERIES ----------------------------------------------------------
-- lists the top 10 highest rated games in the database
SELECT title, metacritic_score, release_date FROM game
ORDER BY metacritic_score DESC
LIMIT 10;

-- find the platform of a game entered by user - search function
SELECT g.title AS game_title, p.name AS platform_name FROM game g INNER JOIN
game_plat gp ON (g.game_id = gp.game_id) INNER JOIN
platform p ON (gp.plat_id = p.id) WHERE g.title = :name_of_game_entered_by_user;

-- display all games with developer names
SELECT g.title AS game_title, d.name AS developer_name FROM
game g INNER JOIN developer d ON (g.developer = d.dev_id);

-- display all games with the publishers
SELECT g.title AS game_title, p.name AS publisher_name FROM
game g INNER JOIN publisher p ON (g.publisher = pub_id);

-- get all genres possible to populate a dropdown
SELECT genre FROM game GROUP BY genre;

-- use dropdown genre result chosen by user to display all games under that genre
SELECT title FROM game WHERE genre = :genre_chosen_from_dropdown;



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
