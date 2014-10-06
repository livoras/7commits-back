express = require 'express'
router = express.Router()
Team = require "../db/models/team.coffee"
_ = require "lodash"
debug = require('debug')('7commits')
{requireAdmin} = require "./helpers.coffee"

router.put '/', requireAdmin, (req, res)->
    teamData = _.pick req.body, "introduction", "shortIntroduction"
    Team.findOneAndUpdate {}, teamData, (err, team)->
        result = {result: "success"}
        if not team
            Team.create teamData, (err, team)-> res.json result
        else
            res.json result

module.exports = router
