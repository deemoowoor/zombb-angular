m = angular.module 'zombb.topic', ['ngResource', 'ui.bootstrap', 'zombb.auth']

m.factory 'Post', ['$resource', ($resource) -> $resource '/posts/:post_id.json']

m.factory 'PostComment', ['$resource', ($resource) -> $resource '/post_comments/:c_id.json']

m.controller 'TopicListCtrl', ['$scope', '$window', 'Post', ($scope, $window, postRes) ->
    $scope.posts = []

    postRes.query (posts) ->
        angular.forEach posts, (post) ->
            $scope.posts.push(post)
    null
]

m.controller 'TopicCtrl', ['$scope', '$window', '$routeParams', 'Post', 'Auth',
($scope, $window, $routeParams, postRes, myAuth) ->
    postRes.get { post_id: $routeParams.topic_id }, (post) ->
        $scope.post = post

    $scope.isLoggedIn = (user) ->
        if myAuth.isAuthenticated() and user and myAuth._currentUser.name == user.name
            return true
        false

    null
]
