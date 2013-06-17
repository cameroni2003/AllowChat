window.socket = io.connect 'http://localhost:8888'

socket.on 'welcome', (data) ->
  socket.emit 'login',
    name: 'cam'

  socket.on 'friendUpdate', (data) ->
    console.log data.friends
