m = angular.module 'zombb.topic',
    ['ngResource', 'ui.bootstrap', 'monospaced.elastic', 'zombb.auth', 'zombb.util']

m.factory 'Post', ['$resource', ($resource) -> ($resource '/posts/:post_id.json', {post_id: '@id'},
    update: { method: 'PUT'})
]

m.factory 'PostComment', ['$resource', ($resource) ->
    ($resource '/posts/:post_id/post_comments/:c_id.json', {post_id: '@post_id', c_id: '@id'},
    update: { method: 'PUT'})
]

m.controller 'TopicListCtrl', ['$scope', '$modal', 'Auth', 'Authorize', 'Post', 'ConfirmDialog',
($scope, $modal, Auth, Authorize, Post, ConfirmDialog) ->
    $scope.Authorize = Authorize

    $scope.posts = []

    Post.query ((posts) -> angular.forEach posts, (post) -> $scope.posts.push(post))

    $scope.deleteTopic = (post) ->
        dialog = ConfirmDialog($scope, {title: 'Confirm delete topic?'})
        doDelete = (res) ->
            post.$delete().then (-> $scope.posts.splice($scope.posts.indexOf(post), 1)),
                ((error) -> $scope.error = error.data)
        dialog.result.then doDelete

    null
]

m.controller 'TopicCtrl', ['$scope', '$routeParams', 'Auth',
'Authorize', 'Post', 'PostComment', 'ConfirmDialog',
($scope, $routeParams, Auth, Authorize, Post, PostComment, ConfirmDialog) ->

    $scope.Authorize = Authorize

    Post.get { post_id: $routeParams.topic_id }, (post) ->
        $scope.post = post

    $scope.editComment = (comment) ->
        comment.editmode = true
        PostComment.get {post_id: $routeParams.topic_id, c_id: comment.id, edit: true}, (rcomment) ->
                $scope.edit_comment = rcomment

    $scope.cancelEditComment = (comment) ->
        comment.editmode = undefined
        $scope.edit_comment = null

    $scope.saveComment = (comment) ->
        comment.editmode = undefined
        $scope.edit_comment.$update post_id: $scope.post.id
        # Reload comment's rendered text
        PostComment.get { post_id: $scope.post.id, c_id: comment.id }, (rcomment) ->
            comment.text = rcomment.text

    $scope.deleteComment = (comment) ->
        dialog = ConfirmDialog($scope, {title: 'Confirm delete comment?'})

        doDelete = (res) ->
            PostComment.get post_id: $scope.post.id, c_id: comment.id, (rcomment) ->
                rcomment.$delete(post_id: $scope.post.id)
                    .then (->
                    comment_index = $scope.post.post_comments.indexOf(comment)
                    $scope.post.post_comments.splice(comment_index, 1)),
                    (error) -> $scope.error = error.data

        dialog.result.then doDelete

    $scope.new_comment = new PostComment()

    $scope.addComment = ->
        $scope.new_comment.$save post_id: $scope.post.id, (rcomment) ->
            $scope.post.post_comments.push rcomment
            $scope.new_comment = new PostComment()

    null
]

m.controller 'TopicEditCtrl', ['$scope', '$routeParams', '$location', 'Post', 'Auth',
($scope, $routeParams, $location, Post, Auth) ->
    $scope.editmode = true

    Post.get { post_id: $routeParams.topic_id, edit: true }, (post) ->
        $scope.post = post

    $scope.submit = ->
        $scope.post.$update()
            .then (->
            Post.get { post_id: $scope.post.id, edit: true }, (post) ->
                $scope.post = post
                $location.path '/topics/' + $scope.post.id),
            ((error) -> $scope.error = error.data)

    null
]

m.controller 'TopicNewCtrl', ['$scope', '$routeParams', '$location', 'Post', 'Auth',
($scope, $routeParams, $location, Post, Auth) ->
    $scope.editmode = true

    $scope.post = new Post()
    $scope.submit = ->
        # TODO: indicate an error message if it fails
        $scope.post.$save()
            .then (->
            Post.get { post_id: $scope.post.id, edit: true}, (post) ->
                $scope.post = post
                $location.path '/topics/' + $scope.post.id),
            ((error) -> $scope.error = error.field)

    null
]
