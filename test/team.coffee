chai = require "chai"
expect = chai.expect
chai.should()

config = require "../config.coffee"
app = require "../app.coffee"
Member = require "../db/models/member.coffee"
util = require "../common/util.coffee"
request = (require "supertest").agent(app)

Team = require "../db/models/team.coffee"

describe "团队信息相关", ->
    before (done)->
        # Login to make tests sense.
        request
            .post("/members/session")
            .send({name: "admin", password: "123456"})
            .end done

    it "保存团队信息", (done)->
        teamData = {"introduction": "SB", "shortIntroduction": "DSB"}
        request
            .put("/team")
            .send(teamData)
            .expect(200)
            .end (err, res)->
                res.body.result.should.equal "success"
                Team.findOne {}, (err, team)->
                    if err then throw err
                    team.introduction.should.equal teamData.introduction
                    team.shortIntroduction.should.equal teamData.shortIntroduction
                    testAfterCreation()
        testAfterCreation = ->
            teamData = {introduction: "cao", shortIntroduction: "hehe"}
            request
                .put("/team")
                .send(teamData)
                .end (err, res)->
                    res.body.result.should.equal "success"
                    Team.findOne {}, (err, team)->
                        if err then throw err
                        team.introduction.should.equal teamData.introduction
                        team.shortIntroduction.should.equal teamData.shortIntroduction
                        done()

    describe "已登录，但无权限修改", ->
        before (done)->
            Member.create {name: "fuck", password: util.encrypt("456789")}, ->
                request
                    .post("/members/session")
                    .send({name: "fuck", password: "456789"})
                    .end done
        it "保存团队信息失败", ->
            teamData = {introduction: "cao", shortIntroduction: "hehe"}
            request
                .put("/team")
                .send(teamData)
                .expect(401)
                .end (err, res)->
                    res.body.result.should.equal "fail"


