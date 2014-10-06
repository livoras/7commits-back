express = require 'express'
router = express.Router()
Member = require "../db/models/member.coffee"
util = require "../common/util.coffee"
{requireLogin} = require "./helpers.coffee"


router.post '/session', (req, res)->
    {name, password} = req.body
    Member.findOne {name}, (err, member)->
        if err
            return res.status(500).send "Server Error."
        if not member
            return res.status(404).json {result: "fail", msg: "Member is not found."}
        if member.password isnt util.encrypt password
            return res.status(400).json {result: "fail", msg: "Password is not correct."}
        req.session.isAdmin = member.isAdmin
        req.session.member = member.toJSON()
        res.json {result: "success"}


router.delete '/session', requireLogin, (req, res)->
    req.session.destroy()
    res.json {result: "success"}

module.exports = router
