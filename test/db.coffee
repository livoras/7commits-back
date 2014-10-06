chai = require "chai"
expect = chai.expect
chai.should()

config = require "../config.coffee"
app = require "../app.coffee"
Sample = require "../db/models/sample.coffee"
clear = (require "mocha-mongoose")(config.TEST_DB_URI)

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

