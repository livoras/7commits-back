chai = require "chai"
expect = chai.expect
chai.should()

Post = require "../db/models/post.coffee"
Tag = require "../db/models/tag.coffee"
Comment = require "../db/models/comment.coffee"
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

    user = null
    postId = null

    before (done)->
        helpers.logout request, -> clear(done)

    after (done)->
        helpers.destroyUser user._id, -> clear(done)

    clear = (done)->
        Post.remove {}, ->
            Comment.remove {}, ->
                Tag.remove {}, done


    describe "新建博文", ->

        it "未登录无法新建博文", (done)->
            request
                .post("/posts")
                .send(postData)
                .expect(401)
                .end done

        it "登陆可以新建博文，自动新增标签", (done)->
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


    describe "删除博文", ->

        it "删除博文，自动删除标签和评论", (done)->
            postData.tags.push "hello"
            postId = null
            post = null

            sendRequest = ->
                request
                    .post("/posts")
                    .send(postData)
                    .expect(200)
                    .end (err, res)->
                        postId = id = res.body.id
                        post = Post.findOne {_id: postId}, (err, thePost)->
                            post = thePost
                            createMockComments deletePost

            createMockComments = (callback)->
                comments = ["FUCK", "YOU"]
                commentsId = []
                count = 0
                checkAndDone = ->
                    count++
                    if count is comments.length
                        post.comments = commentsId
                        post.save ->
                            post.comments.should.has.length 2
                            callback()
                for comment in comments
                    do (comment)-> 
                        Comment.create {content: comment, postId: postId}, (err, comment)->
                            commentsId.push comment._id
                            checkAndDone()

            deletePost = (err, res)->
                request
                    .delete("/posts/#{postId}")
                    .send({})
                    .expect(200)
                    .end testAll

            testAll = (err, res)->
                Post.findOne {_id: postId}, (err, post)->
                    testCommentsDeleted()
                    expect(post).to.not.exist

            testCommentsDeleted = ->
                Comment.count {}, (err, count)->
                    count.should.equal 0
                    testTagsDeleted()

            testTagsDeleted = ->
                count = 0
                checkAndDone = ->
                    count++
                    if count is postData.tags.length then done()
                for tagName in postData.tags
                    do (tagName)->
                        Tag.findOne {name: tagName}, (err, tag)->
                            if count < 2
                                tag.posts.should.has.length 1
                            else
                                expect(tag).to.not.exist
                            checkAndDone()
            sendRequest()


        it "博文不存在", (done)->
            # TODO
            done()

        it "没有权限修改博文", (done)->
            # TODO
            done()
