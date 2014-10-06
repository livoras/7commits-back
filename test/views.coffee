chai = require "chai"
chai.should()
app = require "../app.coffee"
request = (require "supertest")(app)

describe "首页显示", ->
    it "GET / => home.jade", (done)->
        request.get("/")
               .expect(200)
               .expect(/\<!doctype html\>/i, done)
