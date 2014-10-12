express = require 'express'
router = express.Router()
_ = require "lodash"

{requireLogin} = require "./helpers.coffee"
Post = require "../db/models/post.coffee"
Tag =  require "../db/models/tag.coffee"
Comment =  require "../db/models/comment.coffee"

router.post "/", requireLogin, (req, res)->
    postData = req.body
    tagNames = postData.tags
    postData.creator = req.session.member._id
    post = new Post postData
    updateTagsByPost post, tagNames, (tags)->
        post.tags = tags
        post.save -> 
            result = _.extend post.toJSON(), {id: post._id}
            res.json result

router.delete "/:id", requireLogin, (req, res)->
    postId = req.params.id
    Post.findOne {_id: postId}, (err, post)->
        if not post then return res.status(404).json {result: "fail", msg: "Post is not found."}
        if checkPrivilege(post, req)
            return res.status(401).json {result: "fail", msg: "You have no privilege."}
        deletePostAndItsContent postId, res

checkPrivilege = (post, req)->
    req.session.isAdmin or req.session.member._id is post.creator

deletePostAndItsContent = (postId, res)->
    Post.remove {_id: postId}, (err, post)->
        Tag.removeTagsByPostId postId, ->
            Comment.removeCommentsByPostId postId, ->
                res.json {result: "success"}

updateTagsByPost = (post, tagNames, callback)->
    count = 0
    tagIds = []

    checkDone = ->
        if count is 0 then callback?(tagIds)

    for tagName in tagNames
        do (tagName)->
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
