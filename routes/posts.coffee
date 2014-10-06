express = require 'express'
router = express.Router()
_ = require "lodash"

{requireLogin} = require "./helpers.coffee"
Post = require "../db/models/post.coffee"
Tag =  require "../db/models/tag.coffee"

router.post '/', requireLogin, (req, res)->
    postData = req.body
    tagNames = postData.tags
    postData.creator = req.session.member._id
    post = new Post postData
    updateTagsByPost post, tagNames, (tags)->
        post.tags = tags
        post.save -> 
            result = _.extend post.toJSON(), {id: post._id}
            res.json result

updateTagsByPost = (post, tagNames, callback)->
    count = 0
    tagIds = []

    checkDone = ->
        if count is 0 then callback?(tagIds)

    for tagName in tagNames
        Tag.findOne {name: tagName}, (err, tag)->
            if not tag
                Tag.create {name: tagName, posts: [post._id]}, (err, tag)->
                    tagIds.push tag._id
                    checkDone()
            else
                tagIds.push tag._id
                tag.posts.addToSet post._id
                tag.save checkDone

module.exports = router
