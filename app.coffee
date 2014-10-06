express = require 'express'
path = require 'path'
favicon = require 'static-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
busbody = require "connect-busboy"
session = require 'express-session'

db = require "./db/db.coffee"
config = require "./config.coffee"

views_route = require './routes/views.coffee'
admin_route = require './routes/admin.coffee'
comments_route = require './routes/comments.coffee'
members_route = require './routes/members.coffee'
team_route = require './routes/team.coffee'
posts_route = require './routes/posts.coffee'

app = express()

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

app.use favicon()
app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use busbody {immediate: true}
app.use express.static(path.join(__dirname, 'public'))
app.use cookieParser()
app.use session {
    secret: config.SECRET_KEY
    resave: yes
    saveUninitialized: yes
}

app.use '/', views_route
app.use '/admin', admin_route
app.use '/comments', comments_route
app.use '/posts', posts_route
app.use '/team', team_route
app.use '/members', members_route

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

db.init()

module.exports = app
