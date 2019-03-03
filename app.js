var express = require('express');
var mysql = require('mysql');
var bodyParser = require("body-parser");
var handlebars = require("express-handlebars").create({defaultLayout:'main'});
var app = express();

app.engine("handlebars", handlebars.engine);
app.set("view engine", "handlebars");
app.use(bodyParser.urlencoded({extended: false}));

// CREATE CONNECTION OBJECT
var connection = mysql.createConnection(
    {
        host: 'classmysql.engr.oregonstate.edu',
        user: 'cs340_lifr',
        password: '2268',
        database: 'cs340_lifr',
        dateStrings: true
    }
);

// CHECK IF CONNECTION SUCCEEDED
connection.connect(function(err) {
    if (err) {console.log("Unsuccessful connection attempt")}
    else {console.log("Connected successfully to database")};
});

// ------------------------------------------------------------------------------------------------
// GAME ENTITY MAIN PAGE
// ------------------------------------------------------------------------------------------------
app.get("/", function(req, res) {
    // find count of users in db
    var all_games = "SELECT title, developer, publisher, genre, metacritic_score, release_date FROM game ORDER BY metacritic_score DESC";
    var game_dropdown = "SELECT title FROM game";
    var platform_dropdown = "SELECT name FROM platform";
    var developer_dropdown = "SELECT name FROM developer";
    var publisher_dropdown = "SELECT name FROM publisher";
    var genre_dropdown = "SELECT name FROM genre";

    connection.query("SELECT title FROM game", function(err, results) {
        if (err) throw err;
        game_dropdown = results;
    });

    connection.query(platform_dropdown, function(err, results) {
        if (err) throw err;
        platform_dropdown = results;
    });

    connection.query(developer_dropdown, function(err, results) {
        if (err) throw err;
        developer_dropdown = results;
    });

    connection.query(publisher_dropdown, function(err, results) {
        if (err) throw err;
        publisher_dropdown = results;
    });

    connection.query(genre_dropdown, function(err, results) {
        if (err) throw err;
        genre_dropdown = results;
    });

    connection.query(all_games, function(err, results) {
        if (err) throw err;
        res.render("index", {
            results: results,
            platform_dropdown: platform_dropdown,
            game_dropdown: game_dropdown,
            developer_dropdown: developer_dropdown,
            publisher_dropdown: publisher_dropdown,
            genre_dropdown: genre_dropdown
        });
    });
});

// Adding a new game entity via INSERT
app.post("/add_game", function(req, res) {
    var plat_id = "SELECT plat_id FROM platform WHERE name = ?";
    var plat_id_selected = [req.body.platform];

    var pub_id = "SELECT pub_id FROM publisher WHERE name = ?";
    var pub_id_selected = [req.body.publisher];

    var dev_id = "SELECT dev_id FROM developer WHERE name = ?";
    var dev_id_selected = [req.body.developer];

    var genre_id = "SELECT genre_id FROM genre WHERE name = ?";
    var genre_id_selected = [req.body.genre];

    var add_game = "INSERT INTO game SET ?";
    var associate = "INSERT INTO game_plat SET ?";
    
    // get platform id of what user entered in platform field
    connection.query(plat_id, plat_id_selected, function(err, result) {
        if (err) throw err;
        plat_id = result;
        plat_id = plat_id[0].plat_id;
        console.log(plat_id);
        connection.query(pub_id, pub_id_selected, function(err, result) {
            if (err) throw err;
            pub_id = result;
            pub_id = pub_id[0].pub_id;
            console.log(pub_id);
            connection.query(dev_id, dev_id_selected, function(err, result) {
                if (err) throw err;
                dev_id = result;
                dev_id = dev_id[0].dev_id;
                console.log(dev_id);
                connection.query(genre_id, genre_id_selected, function(err, result) {
                    if (err) throw err;
                    genre_id = result;
                    genre_id = genre_id[0].genre_id;
                    console.log(genre_id);
                    // insert this game game object
                    var game = {
                        title: req.body.title,
                        developer: dev_id,
                        publisher: pub_id,
                        genre: genre_id,
                        release_date: req.body.release_date,
                        metacritic_score: req.body.metacritic_score
                    };
                    var game_id = "SELECT game_id FROM game WHERE title = ?";
                    var game_selected = [game.title];
                    console.log("Date", game.release_date);

                    // insert game entity
                    connection.query(add_game, game, function(err, results) {
                        if (err) throw err;
                        // select for the game id of game just inserted
                        connection.query(game_id, game_selected, function(err, result) {
                            if (err) throw err;
                            game_id = result;
                            game_id = game_id[0].game_id;
                            
                            // create object with game_id and plat_id to associate with one another in another query
                            var game_plat = {
                                game_id: game_id,
                                plat_id: plat_id
                            };
                            connection.query(associate, game_plat, function(err, results) {
                                if (err) throw err;
                                res.redirect("/");
                            });
                        });
                    });
                });
            });
        });
    });
});
// ------------------------------------------------------------------------------------------------
// PUBLISHER RELATED ROUTES
// ------------------------------------------------------------------------------------------------
// publisher landing page
app.get("/pub", function(req, res) {
    var pub_dropdown = "SELECT name FROM publisher";
    connection.query(pub_dropdown, function(err, results){
        if (err) throw err;
        pub_dropdown = results;
        res.render("pub", {pub_dropdown: pub_dropdown});
    });
});

// search for games by publisher
app.post("/pub_search", function(req, res){
    var pub_dropdown = "SELECT name FROM publisher";
    connection.query(pub_dropdown, function(err, results){
        if (err) throw err;
        pub_dropdown = results;
    });

    var pub_query = "SELECT g.title AS game_title, d.name AS developer_name, p.name AS publisher_name,\
    gen.name AS genre_name, g.metacritic_score, g.release_date FROM game g\
    INNER JOIN publisher p ON (g.publisher = p.pub_id)\
    INNER JOIN developer d ON (g.developer = d.dev_id)\
    INNER JOIN genre gen ON (g.genre = gen.genre_id)\
    WHERE p.name = ?";
    var pub_selected = [req.body.pub_selected];
    connection.query(pub_query, pub_selected, function(err, results){
        if (err) throw err;
        res.render("pub", {
            results: results,
            pub_dropdown: pub_dropdown
        });
    });
});

// add publisher
app.post("/pub_add", function(req, res){
    var pub = {
        name: req.body.publisher
    };
    connection.query("INSERT INTO publisher SET ?", pub, function(err, results) {
        if (err) throw err;
        res.redirect("/pub");
    });
});

// ------------------------------------------------------------------------------------------------
// PLATFORM RELATED ROUTES
// ------------------------------------------------------------------------------------------------
app.get("/plat", function(req, res){
    var game_dropdown = "SELECT title FROM game";
    var platform_dropdown = "SELECT name FROM platform";
    
    connection.query(game_dropdown, function(err, results) {
        if (err) throw err;
        game_dropdown = results;
    });
    connection.query(platform_dropdown, function(err, results) {
        if (err) throw err;
        platform_dropdown = results;
        res.render("plat", {game_dropdown: game_dropdown, platform_dropdown: platform_dropdown});
    });
});

app.post("/new_plat", function(req, res){
    var add_plat_query = "INSERT INTO platform SET ?";
    var new_platform = {name: req.body.new_plat};
    connection.query(add_plat_query, new_platform, function(err, results){
        if (err) throw err;
        res.redirect("/plat");
    });
});

app.post("/plat_search", function(req, res){
    var plat_query = "SELECT g.title AS game_title, d.name AS developer_name, p.name AS publisher_name,\
        gen.name AS genre_name, g.metacritic_score, g.release_date FROM game g\
        INNER JOIN publisher p ON (p.pub_id = g.publisher)\
        INNER JOIN developer d ON (d.dev_id = g.developer)\
        INNER JOIN genre gen ON (gen.genre_id = g.genre)\
        INNER JOIN game_plat gp ON (gp.game_id = g.game_id)\
        INNER JOIN platform pl ON (pl.plat_id = gp.plat_id)\
        WHERE pl.name = ?";
    var platform_search = [req.body.platform_search];
    connection.query(plat_query, platform_search, function(err, results) {
        if (err) throw err;
        res.render("plat", {results: results});
    });
});

// ------------------------------------------------------------------------------------------------
// GENRE RELATED ROUTES
// ------------------------------------------------------------------------------------------------
// genre landing page
app.get("/genre", function(req, res){
    var genre_dropdown = "SELECT name FROM genre";
    connection.query(genre_dropdown, function(err, results){
        if (err) throw err;
        genre_dropdown = results;
        res.render("genre", {genre_dropdown: genre_dropdown});
    });
});

// querying games by genre
app.post("/genre_search", function(req, res){
    var genre_dropdown = "SELECT name FROM genre";
    connection.query(genre_dropdown, function(err, results){
        if (err) throw err;
        genre_dropdown = results;
    });

    var genre_query = "SELECT g.title AS game_title, d.name AS developer_name, p.name AS publisher_name,\
        gen.name AS genre_name, g.metacritic_score, g.release_date FROM game g\
        INNER JOIN publisher p ON (g.publisher = p.pub_id)\
        INNER JOIN developer d ON (g.developer = d.dev_id)\
        INNER JOIN genre gen ON (g.genre = gen.genre_id)\
        WHERE gen.name = ?";
    var genre_selected = [req.body.genre_selected];
    connection.query(genre_query, genre_selected, function(err, results){
        if (err) throw err;
        res.render("genre", {
            results: results,
            genre_dropdown: genre_dropdown
        });
    });
});

app.post("/genre_add", function(req, res){
    var genre = {
        name: req.body.genre
    };
    connection.query("INSERT INTO genre SET ?", genre, function(err, results ){
        if (err) throw err;
        res.redirect("/genre");
    });
});

// ------------------------------------------------------------------------------------------------
// DEVELOPER RELATED ROUTES
// ------------------------------------------------------------------------------------------------
// developer landing page
app.get("/dev", function(req, res){
    var developer_dropdown = "SELECT name FROM developer";
    connection.query(developer_dropdown, function(err, results){
        if (err) throw err;
        developer_dropdown = results;
        res.render("dev", {developer_dropdown: developer_dropdown});
    });
});

// querying games by developer
app.post("/dev_search", function(req, res){
    var developer_dropdown = "SELECT name FROM developer";
    connection.query(developer_dropdown, function(err, results) {
        if (err) throw err;
        developer_dropdown = results;
    });

    var dev_query = "SELECT g.title AS game_title, d.name AS developer_name, p.name AS publisher_name,\
        gen.name AS genre_name, g.metacritic_score, g.release_date FROM game g\
        INNER JOIN publisher p ON (g.publisher = p.pub_id)\
        INNER JOIN developer d ON (g.developer = d.dev_id)\
        INNER JOIN genre gen ON (g.genre = gen.genre_id)\
        WHERE d.name = ?";
    var dev_selected = [req.body.dev_selected];
    connection.query(dev_query, dev_selected, function(err, results){
        if (err) throw err;
        res.render("dev", {
            results: results,
            developer_dropdown: developer_dropdown
        });
    });
});

// inserting a developer
app.post("/dev_add", function(req, res){
    var developer = {
        name: req.body.developer
    };
    connection.query("INSERT INTO developer SET ?", developer, function(err, results){
        if (err) throw err;
        res.redirect("/dev");
    });
});

app.listen(6553, function(){
    console.log("Server running on 6553");
});