m = angular.module 'zombbControllers', ['ngResource', 'Devise', 'ui.bootstrap']

m.config ['AuthProvider', (AuthProvider) ->
    #AuthProvider.loginPath('http://localhost:3000/users/sign_in.json')
    #AuthProvider.logoutPath('http://localhost:3000/users/sign_out.json')
]

m.factory 'Post', ['$resource', ($resource) -> $resource '/posts.json/:id']
m.factory 'PostComment', ['$resource', ($resource) -> $resource '/post_comments.json/:id']
m.factory 'User', ['$resource', ($resource) -> $resource '/users.json/:id']

m.controller 'AuthCtrl', ['$scope', '$modal', '$window', 'Auth', ($scope, $modal, $window, myAuth) ->
    $scope.logOut = () ->
        myAuth.logout()

    $scope.$on 'devise:logout', (event, oldUser) ->
        $scope.currentUser = null
        $scope.isAuth = false

    $scope.open = (size) ->
        dialog = $modal.open
            templateUrl: 'zombbAuthCtrl.html'
            controller: 'AuthDialogCtrl'
            size: size

    $scope.$on 'devise:login', (event, currentUser) ->
        $scope.currentUser = currentUser
        $scope.isAuth = true

    null
]


m.controller 'AuthDialogCtrl', ['$scope', '$window', 'Auth', '$modalInstance', ($scope, $window, myAuth, dialog) ->
    $scope.doLogin = ->
        res = myAuth.login
            email: $scope.email
            password: $scope.password

        success = (user) ->
            dialog.close(user)

        errcb = (error) -> $scope.error = error

        res.then success, errcb

    $scope.cancel = -> dialog.dismiss('cancel')
    null
]


m.controller 'TopicListCtrl', ['$scope', '$window', 'Post', ($scope, $window, postRes) ->
    $scope.posts = []

    postRes.query (posts) ->
        angular.forEach posts, (post) ->
            $scope.posts.push(post)
]

m.controller 'TopicCtrl', ['$scope', '$window', 'Post', ($scope, $window, postRes) ->
    postRes.get @topic_id, (post) ->
        $scope.post = post

]
