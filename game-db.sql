-- Data Definition Queries for game-db
-- Authors: Frank Li, Joel Huffman

-- Drop tables if already populated
DROP TABLE IF EXISTS `game_plat`;
DROP TABLE IF EXISTS `game`;
DROP TABLE IF EXISTS `developer`;
DROP TABLE IF EXISTS `publisher`;
DROP TABLE IF EXISTS `genre`;
DROP TABLE IF EXISTS `platform`;

-- Create tables
CREATE TABLE `developer` (
	`dev_id` int(11) auto_increment NOT NULL,
	`name` varchar(100) NOT NULL,
	PRIMARY KEY (`dev_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE `developer` auto_increment = 1;

CREATE TABLE `publisher` (
	`pub_id` int(11) auto_increment NOT NULL,
	`name` varchar(100) NOT NULL,
	PRIMARY KEY(`pub_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE `publisher` auto_increment = 1;

CREATE TABLE `genre` (
	`genre_id` int(11) auto_increment NOT NULL,
	`name` varchar(100) NOT NULL,
	PRIMARY KEY(`genre_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE `genre` auto_increment = 1;

CREATE TABLE `platform` (
	`plat_id` int(11) auto_increment NOT NULL,
	`name` varchar(100) NOT NULL,
	PRIMARY KEY(`plat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE `platform` auto_increment = 1;

CREATE TABLE `game` (
	`game_id` int(11) auto_increment NOT NULL,
	`title` varchar(100) NOT NULL,
	`metacritic_score` int(11) DEFAULT NULL,
	`release_date` DATE DEFAULT '0000-00-00', 
	`genre` int(11) NOT NULL,
	`publisher` int(11) NOT NULL,
	`developer` int(11) NOT NULL,
	PRIMARY KEY (`game_id`),
	KEY `genre` (`genre`),
	KEY `publisher` (`publisher`),
	KEY `developer` (`developer`),
	CONSTRAINT `game_ibfk_1` FOREIGN KEY (`genre`) REFERENCES `genre` (`genre_id`),
	CONSTRAINT `game_ibfk_2` FOREIGN KEY (`publisher`) REFERENCES `publisher` (`pub_id`),
	CONSTRAINT `game_ibfk_3` FOREIGN KEY (`developer`) REFERENCES `developer` (`dev_id`),
	UNIQUE KEY `title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE `game` auto_increment = 1;


CREATE TABLE `game_plat` (
	`game_id` int(11) NOT NULL,
	`plat_id` int(11) NOT NULL,
	PRIMARY KEY(`game_id`, `plat_id`),
	KEY `game_id` (`game_id`),
	CONSTRAINT `game_plat_ibfk_1` FOREIGN KEY(`game_id`) REFERENCES `game` (`game_id`) ON DELETE CASCADE,
	CONSTRAINT `game_plat_ibfk_2` FOREIGN KEY(`plat_id`) REFERENCES `platform` (`plat_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE `game_plat` auto_increment = 1;

-- Data Dump
INSERT INTO `developer` VALUES
(1, 'From Software'),
(2, 'Bungie'),
(3, 'Capcom'),
(4, 'Epic Games'),
(5, 'Bandai Namco'),
(6, 'Electronic Arts');

INSERT INTO `publisher` VALUES
(1, 'Nintendo'),
(2, 'Electronic Arts'),
(3, 'Sony Computer Entertainment'),
(4, 'Activision'),
(5, 'Capcom'),
(6, 'Epic Games'),
(7, 'Bandai Namco');

INSERT INTO `genre` VALUES
(1, 'Shooter'),
(2, 'RPG'),
(3, 'Side-scroller'),
(4, 'Puzzle'),
(5, 'Fighting'),
(6, 'Battle Royale');

INSERT INTO `platform` VALUES
(1, 'Xbox One'),
(2, 'PlayStation 4'),
(3, 'Switch'),
(4, 'Windows PC'),
(5, 'macOS');

INSERT INTO `game` VALUES
(1, 'Bloodborne', 92, '2015-03-24', 2, 3, 1),
(2, 'Dark Souls 3', 89, '2016-04-12', 2, 7, 1),
(3, 'Fortnite', 78, '2017-07-21', 6, 6, 4),
(4, 'Destiny 2', 85, '2017-09-06', 1, 4, 2),
(5, 'Super Smash Bros. Ultimate', 93, '2018-12-07', 5, 1, 5),
(6, 'Resident Evil 2', 91, '2019-01-25', 2, 5, 3);

INSERT INTO `game_plat` VALUES
(1, 2),
(2, 1),(2, 2),(2, 3),(2, 4),
(3, 1),(3, 2),(3, 3),(3, 4),(3, 5),
(4, 1),(4, 2),(4, 4),
(5, 3),
(6, 1),(6, 2),(6, 4);