-- Data Definition Queries for game-db
-- Authors: Frank Li, Joel Huffman

CREATE TABLE `game` (
	`game_id` int(11) auto_increment NOT NULL,
	`title` varchar(100) NOT NULL,
	`score` int(11) DEFAULT NULL,
	`release_date` DATE DEFAULT 0000-00-00, 
	`genre` int(11) NOT NULL,
	`publisher` int(11) NOT NULL,
	`developer` int(11) NOT NULL,
	PRIMARY KEY(`game_id`),
	FOREIGN KEY(`genre`) REFERENCES genre(`genre_id`),
	FOREIGN KEY(`publisher`) REFERENCES publisher(`pub_id`),
	FOREIGN KEY(`developer`) REFERENCES developer(`dev_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE `game` auto_increment = 1;

CREATE TABLE `developer` (
	`dev_id` int(11) auto_increment NOT NULL,
	`name` varchar(100) NOT NULL,
	PRIMARY KEY(`dev_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE `developer` auto_increment = 1;

CREATE TABLE `publisher` (
	`pub_id` int(11) auto_increment NOT NULL,
	`name` varchar(100) NOT NULL,
	PRIMARY KEY(`pub_id`),	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE `publisher` auto_increment = 1;

CREATE TABLE `genre` (
	`genre_id` int(11) auto_increment NOT NULL,
	`name` varchar(100) NOT NULL,
	PRIMARY KEY(`genre_id`),	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE `genre` auto_increment = 1;

CREATE TABLE `platform` (
	`platform_id` int(11) auto_increment NOT NULL,
	`name` varchar(100) NOT NULL,
	PRIMARY KEY(`platform_id`),	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE `platform` auto_increment = 1;

CREATE TABLE `game_plat` (
	`gameplat_id` int(11) auto_increment NOT NULL,
	`game_id` int(11) NOT NULL,
	`plat_id` int(11) NOT NULL,
	PRIMARY KEY(`gameplat_id`),
	FOREIGN KEY(`game_id`) REFERENCES game(`game_id`),
	FOREIGN KEY(`plat_id`) REFERENCES platform(`platform_id`)	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE `game_plat` auto_increment = 1;


-- Data Dump
INSERT INTO `developer` (`name`) VALUES
(`From Software`),
(`Bungie`),
(`Capcom`),
(`Epic Games`),
(`Bandai Namco Studios`)
(`Electronic Arts`);

INSERT INTO `publisher` (`name`) VALUES
(`Nintendo`),
(`Electronic Arts`),
(`Sony Computer Entertainment`)
(`Activision`)
(`Capcom`)
(`Epic Games`);

INSERT INTO `game` (`title`, `score`, `release_date`, `genre`, `publisher`, `developer`) VALUES
(, )