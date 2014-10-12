mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

commentSchema = new Schema
    postId: ObjectId
    email: String
    name: String
    content: String
    createTime: {type: Date, default: Date.now()}
    isReply: {type: Boolean, default: no}

Comment = mongoose.model "Comment", commentSchema

Comment.removeCommentsByPostId = (postId, callback)->
    Comment.remove {postId: postId}, (err, comment)->
        if err then throw err
        callback()

module.exports = Comment
