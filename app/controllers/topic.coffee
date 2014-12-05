m = angular.module 'zombb.topic', ['ngResource', 'ui.bootstrap', 'monospaced.elastic', 'zombb.auth']

m.factory 'Post', ['$resource', ($resource) -> ($resource '/posts/:post_id.json', {post_id: '@id'},
    update: { method: 'PUT'})
]

m.factory 'PostComment', ['$resource', ($resource) -> $resource '/post_comments/:c_id.json']

m.factory 'ConfirmDialog', ['$modal', ($modal) ->
    ($scope) ->
        $scope.templateUrl = null
        $scope.template = '<div class="modal-header">
            <h3 class="modal-title">Confirm delete?</h3>
        </div>
        <div class="modal-body">
            <input type="submit" value="Delete" class="btn btn-success" ng-click="ok()" />
            <button class="btn btn-default" ng-click="cancel()">Cancel</button>
        </div>'

        dialog = $modal.open
            templateUrl: $scope.templateUrl
            template: $scope.template
            controller: 'ConfirmDialogCtrl'
            controllerAs: 'deleteDialog'
            scope: $scope
]

m.controller 'ConfirmDialogCtrl', ['$scope', '$modalInstance', ($scope, dialog) ->
    @scope = $scope

    $scope.ok = -> dialog.close true
    $scope.cancel = -> dialog.dismiss 'cancel'

    null
]

m.controller 'TopicListCtrl', ['$scope', '$modal', 'Post', 'ConfirmDialog',
($scope, $modal, Post, ConfirmDialog) ->
    $scope.posts = []

    Post.query (posts) ->
        angular.forEach posts, (post) ->
            $scope.posts.push(post)

    $scope.confirmDeleteTopic = (post) ->
        dialog = ConfirmDialog($scope)
        dialog.result.then ((res) -> $scope.deleteTopic(post)),
                            ((error) -> $scope.error = error)

    $scope.deleteTopic = (post) ->
        post.$delete()
        $scope.posts.splice($scope.posts.indexOf(post), 1)

    null
]

m.controller 'TopicCtrl', ['$scope', '$routeParams', 'Post', 'Auth',
($scope, $routeParams, Post, Auth) ->
    Post.get { post_id: $routeParams.topic_id }, (post) ->
        $scope.post = post

    # TODO; move into a separate service
    $scope.isLoggedIn = (user) ->
        if Auth.isAuthenticated() and user and Auth._currentUser.name == user.name
            return true
        false

    $scope.editComment = (comment) ->
        # TODO: implement form display and binding
        null

    $scope.deleteComment = (comment) ->
        # TODO: implement a modal confirmation dialog display and deletion
        null

    $scope.comment = new PostComment()

    $scope.addComment = ->
        $scope.comment.$save()

    null
]

m.controller 'TopicEditCtrl', ['$scope', '$routeParams', 'Post', 'Auth',
($scope, $routeParams, Post, Auth) ->
    $scope.editmode = true

    Post.get { post_id: $routeParams.topic_id, edit: true }, (post) ->
        $scope.post = post

    $scope.submit = ->
        $scope.post.$update().then ->
            Post.get { post_id: $scope.post.id, edit: true }, (post) ->
                $scope.post = post

    null
]

m.controller 'TopicNewCtrl', ['$scope', '$routeParams', 'Post', 'Auth',
($scope, $routeParams, Post, Auth) ->
    $scope.editmode = true

    $scope.post = new Post()
    $scope.submit = ->
        $scope.post.$save().then ->
            Post.get { post_id: $scope.post.id, edit: true }, (post) ->
                $scope.post = post

    null
]

m.controller 'CommentEditCtrl', ['$scope', '$routeParams', 'PostComment', 'Auth',
($scope, $routeParams, PostComment, Auth) ->
    $scope.editmode = true

    PostComment.get { comment_id: $routeParams.comment_id, edit: true }, (post) ->
        $scope.comment = comment

    $scope.submit = -> $scope.comment.$save()
    null
]
