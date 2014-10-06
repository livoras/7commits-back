helpers = exports

helpers.requireLogin = (req, res, next)->
    if not req.session.member
        res.status(401).json {result: "fail", msg: "Please login first."}
    else
        next()

helpers.requireAdmin = (req, res, next)->
    if not req.session.member
        res.status(401).json {result: "fail", msg: "Please login first."}
    else if not req.session.member.isAdmin
        res.status(401).json {result: "fail", msg: "You have no privilege."}
    else
        next()
