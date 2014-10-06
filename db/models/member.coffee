mongoose = require "mongoose"
Schema = mongoose.Schema

memberSchema = new Schema
    name: String
    passoword: String
    avatar: String
    email: String
    signature: String
    introduction: String
    isAdmin: {type: Boolean, default: no}
    showMember: {type: Boolean, default: yes}

Member = mongoose.model "Member", memberSchema
module.exports = Member 
