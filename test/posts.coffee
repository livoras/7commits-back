chai = require "chai"
expect = chai.expect
chai.should()

Post = require "../db/models/post.coffee"
Tag = require "../db/models/tag.coffee"
config = require "../config.coffee"
app = require "../app.coffee"
request = (require "supertest").agent (app)
helpers = require "./helpers.coffee"

describe "博文相关", ->
    postData = 
        content: "Good"
        title: "Big TITLE"
        tags: ["livoras", "github"]
        isPublic: yes

    describe "新建博文", ->
        user = null
        postId = null

        before (done)->
            helpers.logout request, done

        after (done)->
            helpers.destroyUser user._id, ->
                Post.remove {_id: postId}, ->
                    Tag.remove {}, done

        it "未登录无法新建博文", (done)->
            request
                .post("/posts")
                .send(postData)
                .expect(401)
                .end done

        it "登陆可以新建博文", (done)->
            sendRequest = ->
                helpers.createNewUserAndLogin request, (newUser)->
                    user = newUser
                    request
                        .post("/posts")
                        .send(postData)
                        .expect(200)
                        .end (err, res)->
                            postId = id = res.body.id
                            checkPostAndTags(id)

            checkPostAndTags = (id)->
                Post.findOne {_id: id}, (err, post)->
                    ('' + post.creator).should.equal ('' + user._id)
                    post.tags.length.should.equal postData.tags.length
                    post.content.should.equal postData.content
                    post.isPublic.should.equal postData.isPublic
                    checkTags(id)

            checkTags = (id)->
                count = 0
                checkAndDone = ->
                    count++
                    if count is postData.tags.length then done()
                Tag.find {}, (err, tags)->
                    for tag in tags
                        tag.posts.should.include id
                        checkAndDone()
                        
            sendRequest()
