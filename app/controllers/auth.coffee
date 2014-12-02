m = angular.module 'zombb.auth', ['ngResource', 'Devise', 'ui.bootstrap']

m.config ['AuthProvider', (AuthProvider) ->
    #AuthProvider.loginPath('http://localhost:3000/users/sign_in.json')
    #AuthProvider.logoutPath('http://localhost:3000/users/sign_out.json')
]

m.factory 'User', ['$resource', ($resource) -> $resource '/users/:user_id.json']

m.controller 'AuthCtrl', ['$scope', '$modal', 'Auth',
($scope, $modal, myAuth) ->
    @scope = $scope

    $scope.logOut = () ->
        myAuth.logout()

    $scope.$on 'devise:logout', (event, oldUser) ->
        $scope.currentUser = null
        $scope.isAuth = false

    $scope.templateUrl = 'zombbAuthCtrl.html'
    $scope.template = null

    $scope.open = (size) ->
        dialog = $modal.open
            templateUrl: $scope.templateUrl
            template: $scope.template
            controller: 'AuthDialogCtrl'
            controllerAs: 'dialog'
            size: size

    $scope.$on 'devise:login', (event, currentUser) ->
        $scope.currentUser = currentUser
        $scope.isAuth = true

    null
]

m.controller 'AuthDialogCtrl', ['$scope', '$window', 'Auth', '$modalInstance',
($scope, $window, myAuth, dialog) ->
    @scope = $scope

    $scope.doLogin = ->
        res = myAuth.login
            email: $scope.email
            password: $scope.password

        success = (user) -> dialog.close(user)
        errcb = (error) -> $scope.error = error

        res.then success, errcb

    $scope.cancel = -> dialog.dismiss('cancel')

    null
]
