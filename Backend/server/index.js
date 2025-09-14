// Imports
const express = require('express');
const mongoose = require('mongoose');
const http = require('http');
const create = require("axios");
const {connection} = require("mongoose");


//create server

const app = express();
const port = process.env.PORT || 3000
var server = http.createServer(app);
var io = require('socket.io')(server);

// middle ware
app.use(express.json())


// connect to mongodb
const db = process.env.MONGO_URI;
mongoose.connect(db).then(() => {
    console.log("connect successful with mongodb")
}).catch((e) => {
    console.log(e);
})


// listen the socketio from the flutter

io.on("connection", (socket) => {
    console.log("New client connected:", socket.id);

    socket.on('test', (data) => {
        console.log("Received test event:", data);
    });

    socket.on("disconnect", () => {
        console.log("Client disconnected:", socket.id);
    });
});


// listen server

server.listen(port, "0.0.0.0", () => {
    console.log(`server started on port ${port}`)
})

