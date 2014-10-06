chai = require "chai"
chai.should()
app = require "../app.coffee"
request = (require "supertest")(app)

describe "首页显示", ->
    it "请求/，应该返回首页的页面", (done)->
        request.get("/")
               .expect(200)
               .expect(/\<!doctype html\>/i, done)
