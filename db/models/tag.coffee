mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

tagSchema = new Schema
    name: String
    posts: [ObjectId]

Tag = mongoose.model "Tag", tagSchema

Tag.removeTagsByPostId = (postId, callback)->
    Tag.update {posts: postId}, {$pull: {posts: postId}}, {multi: yes}, (err, results)->
        if err then throw err
        Tag.remove {posts: {$size: 0}}, (err, results)->
            if err then throw err
            callback()

module.exports = Tag
