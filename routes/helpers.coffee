helpers = exports

helpers.requireAdmin = (req, res, next)->
    if not req.session.isAdmin
        res.status(401).json {result: "Please login first."}
    else
        next()
