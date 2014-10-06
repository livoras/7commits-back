mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

tagSchema = new Schema
    name: String
    posts: [ObjectId]

Tag = mongoose.model "Tag", tagSchema
module.exports = Tag
