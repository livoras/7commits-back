mongoose = require "mongoose"
Schema = mongoose.Schema

commentSchema = new Schema
    email: String
    name: String
    content: String
    createTime: {type: Date, default: Date.now()}
    isReply: {type: Boolean, default: no}

Comment = mongoose.model "Comment", commentSchema
module.exports = Comment
