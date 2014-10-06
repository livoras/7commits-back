chai = require "chai"
expect = chai.expect
chai.should()

config = require "../config.coffee"
app = require "../app.coffee"
clear = (require "mocha-mongoose")(config.TEST_DB_URI)

Sample = require "../db/models/sample.coffee"
Team = require "../db/models/team.coffee"
Post = require "../db/models/post.coffee"
Comment = require "../db/models/comment.coffee"
Tag = require "../db/models/tag.coffee"
Member = require "../db/models/member.coffee"

describe "每个测试用例后会清空数据库", ->
    id = null

    it "新增一个数据", (done)->
        Sample.create {name: "FUCK"}, (err, data)-> 
            data.name.should.equal "FUCK"
            id = data._id
            done()

    it "数据应该找不到", (done)->
        Sample.findOne {_id: id}, (err, data)->
            if err then done()
            expect(data).to.not.exist
            done()

