// Imports
const express = require('express');
const mongoose = require('mongoose');
const http = require('http');
const create = require("axios");
const {connection} = require("mongoose");
const Game = require('./models/game')
const dotenv = require('dotenv')
const getSentence = require("./api/getSentence");
const {raw} = require("express");


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
                socketId: socket.id, nickname: nickname, isPartyLeader: true
            };
            let game = new Game({
                words: sentence, player: [player],


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

    // Join Game

    socket.on('join-game', async ({nickname, gameId}) => {
        try {
            if (!gameId.match(/^[0-9a-fA-F]{24}$/)) {
                socket.emit('notCorrectGame', 'Please enter the correct Id');
                return;
            }
            let game = await Game.findById(gameId);
            if (game.isJoin) {
                const id = game._id.toString();
                let player = {
                    nickname: nickname, socketId: socket.id,

                }
                console.log(player)
                socket.join(id);
                game.player.push(player);
                game = await game.save();
                io.to(gameId).emit('updateGame', game);

            } else {
                socket.emit('notCorrectGame', 'The game is in progress please try later')
            }
        } catch (e) {
            console.log(e)
        }
    });

    //UserInput

    socket.on('userInput', async ({userInput, gameId}) => {
        let game = await Game.findById(gameId);
        if (!game.isJoin && !game.isOver) {
            let players = game.player.find((playerr) => playerr.socketId === socket.id);
            if (game.words[players.currentWordIndex] === userInput.trim()) {
                players.currentWordIndex = players.currentWordIndex + 1;
                if (players.currentWordIndex !== game.words.length) {
                    game = await game.save();
                    io.to(gameId).emit("updateGame", game);
                } else {
                    let endTime = new Date().getTime();
                    let {startTime} = game;
                    players.WPM = calculateWPM(endTime, startTime, players);
                    game = await game.save();
                    socket.emit('done');
                    io.to(gameId).emit("updateGame", game);
                }
            }

        }
    })


    // Timer Listener

    socket.on('timer', async ({playerId, gameId}) => {
        let countDown = 5;
        let game = await Game.findById(gameId);
        let players = game.player.id(playerId);
        if (players.isPartyLeader) {
            let timeId = setInterval(async () => {
                if (countDown >= 0) {
                    io.to(gameId).emit("timer", {countDown, msg: "Game Starting"});
                    console.log(countDown);
                    countDown--;
                } else {
                    game.isJoin = false;
                    game = await game.save();
                    io.to(gameId).emit("updateGame", game);
                    startGameClock(gameId);
                    clearInterval(timeId);
                }
            }, 1000)
        }

    });

    socket.on("disconnect", () => {
        console.log("Client disconnected:", socket.id);
    });
});


const startGameClock = async (gameId) => {
    let game = await Game.findById(gameId);
    game.startTime = new Date().getTime();
    game = await game.save();

    let time = 120;
    let timeId = setInterval(( function gameIntervalFunc() {
        if (time > 0) {
            const timeFormat = calculateTime(time);
            io.to(gameId).emit("timer", {
                countDown: timeFormat, msg: "Time Remaining"
            })
            console.log(time)
            time--;
        } else {
            (async()=>{
                try {
                    let endTime = new Date().getTime();
                    let game = await Game.findById(gameId);
                    let {startTime} = game;
                    game.isOver = true;
                    game.player.forEach((players, index) => {
                        if (players.WPM === -1) {
                            game.player[index].WPM = calculateWPM(endTime, startTime, players);
                        }
                    })
                    game = await game.save();
                    io.to(gameId).emit("updateGame", game);
                    clearInterval(timeId);
                }catch (e) {
                    console.log(e);
                }
            })()
        }
        return gameIntervalFunc;
    })(), 1000)

}

const calculateTime = (time) => {
    let min = Math.floor(time / 60);
    let sec = time % 60;
    return `${min}:${sec < 10 ? "0" + sec : sec}`;

}

const calculateWPM = (endTime, startTime, players) => {
    const timeTakenInMin = (endTime - startTime) / 60000;
    return Math.floor(players.currentWordIndex / timeTakenInMin);
}


// listen server

server.listen(port, "0.0.0.0", () => {
    console.log(`server started on port ${port}`)
})