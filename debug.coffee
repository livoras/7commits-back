app = require "./app.coffee"
debug = require('debug')('7commits')

app.set 'port', process.env.PORT or 3000

server = app.listen app.get('port'), ->
    debug 'Express server listening on port ' + server.address().port
