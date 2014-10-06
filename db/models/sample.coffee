mongoose = require "mongoose"
Schema = mongoose.Schema

sampleSchema = new Schema
    name: String
    content: String

SampleSchema = mongoose.model "SampleSchema", sampleSchema
module.exports = SampleSchema
