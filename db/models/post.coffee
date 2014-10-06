mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

postSchema = new Schema
    createTime: {type: Date, defualt: Date.now()}
    editTime: {type: Date, defualt: Date.now()}
    title: String
    content: String
    creator: ObjectId
    comments: [ObjectId]
    tags: [ObjectId]
    isPublic: {type: Boolean, defualt: yes}

Post = mongoose.model "Post", postSchema
module.exports = Post
