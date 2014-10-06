mongoose = require "mongoose"
Schema = mongoose.Schema

teamSchema = new Schema
    introduction: String
    shortIntroduction: String

Team = mongoose.model "Team", teamSchema
module.exports = Team
