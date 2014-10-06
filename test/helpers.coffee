Member = require "../db/models/member.coffee" 
util = require "../common/util.coffee"
helpers = exports
uuid = require "node-uuid"

helpers.createNewUserAndLogin = (request, callback)->
    name = uuid.v4()
    Member.create {name: name, password: util.encrypt(name)}, (err, user)->
        request
            .post("/members/session")
            .send({name: name, password: name})
            .expect(200)
            .end (err, res)-> 
                if err then throw err
                callback?(user)

helpers.destroyUser = (_id, callback)-> 
    Member.remove {_id}, callback

helpers.logout = (request, callback)-> 
    request
        .delete("/members/session")
        .end callback
