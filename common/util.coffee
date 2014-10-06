crypto = require "crypto"

util = exports

util.encrypt = (str)->
    shaum = crypto.createHash "sha1"
    shaum.update str
    shaum.digest "hex"
