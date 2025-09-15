// Imports
const express = require('express');
const mongoose = require('mongoose');
const http = require('http');
const create = require("axios");
const {connection} = require("mongoose");
const Game = require('./models/game')
const dotenv = require('dotenv')
const getSentence = require("./api/getSentence");


// env files
dotenv.config();


//create server

const app = express();
const port = process.env.PORT || 3003
var server = http.createServer(app);
var io = require('socket.io')(server);

// middle ware
app.use(express.json())


// connect to mongodb
const Db = process.env.MONGO_URL
mongoose.connect(Db).then(() => {
    console.log("connect successful with mongodb")
}).catch((e) => {
    console.log(e);
})


// listen the socketio from the flutter

io.on("connection", (socket) => {
    console.log("New client connected:", socket.id);

    socket.on('create-game', async ({nickname}) => {
        try {


            const sentence = await getSentence();

            let player = {
                socketId: socket.id,
                nickname: nickname,
                isPartyLeader: true
            };
            let game = new Game({
                words: sentence,
                player: [player],


            });
            game = await game.save();
            const gameId = game._id.toString();
            socket.join(gameId);
            io.to(gameId).emit('updateGame', game);

            console.log("Game created:", game);


        } catch (e) {
            console.log(e);
        }
    });

    socket.on("disconnect", () => {
        console.log("Client disconnected:", socket.id);
    });
});


// listen server

server.listen(port, "0.0.0.0", () => {
    console.log(`server started on port ${port}`)
})