require('nodetime').profile
    accountKey: '0ca4fdc41d5267e641c1bda3acc85f54f95a7126'
    appName: 'Node.js LiveApp Maker'
    
express = require 'express'
path = require 'path'
favicon = require 'static-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
busbody = require "connect-busboy"

db = require "./db/db.coffee"
index_route = require './routes/index.coffee'

app = express()

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

app.use favicon()
app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use busbody {immediate: true}
app.use cookieParser()
app.use express.static(path.join(__dirname, 'public'))

app.use '/', index_route

app.use (req, res, next)->
    err = new Error 'Not Found'
    err.status = 404
    next err

if process.env.NODE_ENV is "DEV"
    app.use (err, req, res, next)->
        res.status err.status or 500
        res.render 'error', {
            message: err.message
            error: err
        }

app.use (err, req, res, next)->
    res.status err.status or 500
    res.render 'error', {
        message: err.message
        error: {}
    }

module.exports = app
