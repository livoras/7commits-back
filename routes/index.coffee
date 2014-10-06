express = require 'express'
router = express.Router()

router.get '/', (req, res)->
    # res.json {"FUCK": "YOU"}
    res.render "home"

module.exports = router
