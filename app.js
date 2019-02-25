var express = require('express');
var mysql = require('mysql');
var bodyParser = require("body-parser");
var handlebars = require("express-handlebars").create({defaultLayout:'main'});
var app = express();

app.engine("handlebars", handlebars.engine);
app.set("view engine", "handlebars");
app.use(bodyParser.urlencoded({extended: false}));

var connection = mysql.createConnection(
    {
        host: 'classmysql.engr.oregonstate.edu',
        user: 'cs340_lifr',
        database: 'cs340_lifr',
        password: "2268"
    });

app.get("/", function(req, res) {
    // find count of users in db
    var top10 = "SELECT title, developer, publisher, genre, metacritic_score, release_date FROM game ORDER BY metacritic_score DESC LIMIT 10";
    var game_dropdown = "SELECT title FROM game";
    var platform_dropdown = "SELECT name FROM platform";
    var developer_dropdown = "SELECT name FROM developer";
    var publisher_dropdown = "SELECT name FROM publisher";
    var genre_dropdown = "SELECT name FROM genre";

    connection.query(game_dropdown, (err, results) => {
        if (err) throw err;
        game_dropdown = results;
    });

    connection.query(platform_dropdown, (err, results) => {
        if (err) throw err;
        platform_dropdown = results;
    });

    connection.query(developer_dropdown, (err, results) => {
        if (err) throw err;
        developer_dropdown = results;
    });

    connection.query(publisher_dropdown, (err, results) => {
        if (err) throw err;
        publisher_dropdown = results;
    });

    connection.query(genre_dropdown, (err, results) => {
        if (err) throw err;
        genre_dropdown = results;
    });

    connection.query(top10, function(err, results){
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

// app.post("/register", function(req, res) {
//     var person = {
//         email: req.body.email
//     };
//     connection.query("INSERT INTO users SET ?", person, function(err, results)
//     {
//         if (err) throw err;
//         res.redirect("/");
//     })
// });

app.listen(8080, function() {
    console.log("Server running on 8080");
});

// connection.end();