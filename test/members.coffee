chai = require "chai"
expect = chai.expect
chai.should()

Member = require "../db/models/member.coffee"
config = require "../config.coffee"
app = require "../app.coffee"
clear = (require "mocha-mongoose")(config.TEST_DB_URI, {noClear: true})
request = (require "supertest").agent (app)

describe "测试成员相关操作", ->

    describe "成员登陆", ->
        it "有一个默认的管理员成员", (done)->
            Member.count {isAdmin: yes}, (err, count)->
                count.should.be.above(0)
                done()

        it "管理员登陆，成功", (done)->
            request.post("/members/session")
                   .send({name: "admin", password: "123456"})
                   .expect(200)
                   .expect("set-cookie", /connect\.sid/)
                   .end (err, res)->
                        res.body.result.should.equal "success"
                        done()

        it "管理员登陆，密码错误", (done)->
            request.post("/members/session")
                   .send({name: "admin", password: "1234"})
                   .expect(400)
                   .end (err, res)->
                        res.body.result.should.equal "fail"
                        res.body.msg.should.equal "Password is not correct."
                        done()

        it "管理员登陆，用户不存在", (done)->
            request.post("/members/session")
                   .send({name: "admifuckn", password: "1234"})
                   .expect(404)
                   .end (err, res)->
                        res.body.result.should.equal "fail"
                        res.body.msg.should.equal "Member is not found."
                        done()

    describe "成员登出", ->
        before (done)->
            request.post("/members/session")
                   .send({name: "admin", password: "123456"})
                   .end done

        it "登出", (done)->
            request.delete("/members/session")
                   .send({})
                   .expect(200)
                   .end (err, res)->
                        res.body.result.should.equal "success"
                        done()

        it "无登陆登出，失败", (done)->
            request.delete("/members/session")
                   .send({})
                   .expect(400)
                   .end (err, res)->
                        res.body.result.should.equal "Please login first."
                        done()
