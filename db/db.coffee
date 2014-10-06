mongoose = require "mongoose"
debug = (require "debug")("7commits")
config = require "../config.coffee"

if process.env.NODE_ENV is "DEV"
    debug "Use Test Database."
    mongoose.connect config.TEST_DB_URI
else
    mongoose.connect config.PRODUCTION_DB_URI

db = mongoose.connection
module.exports = db
