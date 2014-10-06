mongoose = require "mongoose"
Schema = mongoose.Schema
util = require "../../common/util.coffee"

memberSchema = new Schema
    name: String
    password: String
    avatar: {type: String, default: "default.jpg"}
    email: String
    signature: String
    introduction: String
    isAdmin: {type: Boolean, default: no}
    showMember: {type: Boolean, default: yes}

Member = mongoose.model "Member", memberSchema

Member.createDefaultAdministrator = (callback)->
    callback = callback or ->
    Member.count {}, (err, count)->
        if count isnt 0 then callback?(err, count)
        createAdministrator callback

    createAdministrator = (err, count)->
        Member.create {
            name: "admin", 
            password: util.encrypt "123456"
            email: "admin@7commits.com"
            signature: "We Make WWW Fun."
            isAdmin: yes
            introduction: "I am the very first administrator!"
            showMember: no
        }, callback

module.exports = Member 
