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

MemberSchema = mongoose.Schema
  name: String
  allowedChat: [
    type: Schema.Types.ObjectId
    ref: 'Member'
  ]

Member = mongoose.model 'Member', MemberSchema

Member.find(
  name: 'cam'
).lean().exec (err, docs) ->
  if not docs.length
    cam = new Member
      name: 'cam'
    cam.save()

Member.find(
  name: 'jake'
).exec (err, members) ->
  if not members.length
    jake = new Member
      name: 'jake'
    jake.save()

express = require 'express'
app = express()
server = require('http').createServer app
io = require('socket.io').listen server

app.use express.static(__dirname + '/public')
server.listen 8888


io.sockets.on 'connection', (socket) ->
  socket.emit 'welcome',
    msg: 'connected!'

  socket.on 'login', (data) ->
    Member.find(
      name: data.name
    ).exec (err, members) ->
      console.log err
      if members.length is 1
        socket.set 'member', members[0], ->
          socket.emit "welcome #{members[0].name}"
          # populate friends
          socket.emit 'friendUpdate',
            friends: members[0].allowedChat
      else
        socket.emit "Unknown user: #{data.name}"

  socket.on 'addFriend', (data) ->
    Member.find(
      name: data.friendId
    ).exec (err, members) ->
      if err
        console.log err
        console.log "didn't find friend #{data.friendId}"
        return

      socket.get 'member', (err, member) ->
        console.log member
        if members.length is 1
          friend = members[0]
          member.allowedChat.push friend
          member.save()
          console.log "adding #{friend.name} to #{member.name}'s friend list"