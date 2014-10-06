express = require 'express'
router = express.Router()

router.get '/login', (req, res)->
    res.render "home"

module.exports = router
