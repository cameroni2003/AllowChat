creds = require './credentials'

mongoose = require 'mongoose'
Schema = mongoose.Schema

mongoose.connect creds.connectionString
db = mongoose.connection

db.on 'error', ->
  console.error 'error connecting'
  process.exit 1
db.once 'open', ->
  console.log 'connected to mongo server'

UserSchema = mongoose.Schema
  name: String
  allowedChat: [
    type: Schema.Types.ObjectId
    ref: 'User'
  ]

User = mongoose.model 'User', UserSchema

app = require('express')()
server = require('http').createServer app
io = require('socket.io').listen server

server.listen 80

io.sockets.on 'connection', (socket) ->
  socket.emit ''