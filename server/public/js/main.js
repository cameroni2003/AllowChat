// Generated by CoffeeScript 1.6.3
(function() {
  window.socket = io.connect('http://localhost:8888');

  socket.on('welcome', function(data) {
    socket.emit('login', {
      name: 'cam'
    });
    return socket.on('friendUpdate', function(data) {
      return console.log(data.friends);
    });
  });

}).call(this);

/*
//@ sourceMappingURL=main.map
*/
