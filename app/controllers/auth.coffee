m = angular.module 'zombb.auth', ['ngResource', 'Devise', 'ui.bootstrap']

m.config ['AuthProvider', (AuthProvider) ->
    #AuthProvider.loginPath('http://localhost:3000/users/sign_in.json')
    #AuthProvider.logoutPath('http://localhost:3000/users/sign_out.json')
]

m.run ['Auth', (Auth) ->
    # Restore authenticated state on startup
    Auth.login()
]

m.factory 'User', ['$resource', ($resource) -> $resource '/users/:user_id.json']

m.controller 'AuthCtrl', ['$scope', '$modal', 'Auth', ($scope, $modal, myAuth) ->
    @scope = $scope

    $scope.logOut = -> myAuth.logout()

    $scope.templateUrl = 'zombbAuthCtrl.html'
    $scope.template = null

    $scope.error_handler = (error) -> $scope.error = error

    $scope.open = (size) ->
        dialog = $modal.open
            templateUrl: $scope.templateUrl
            template: $scope.template
            controller: 'AuthDialogCtrl'
            controllerAs: 'authDialog'
            size: size

        dialog.result.then $scope.doLogin, $scope.error_handler

        dialog

    $scope.doLogin = (credentials) ->
        res = myAuth.login credentials

        success = () ->
        res.then success, $scope.error_handler

    $scope.$on 'devise:login', (event, currentUser) ->
        $scope.currentUser = currentUser
        $scope.isAuth = true

    $scope.$on 'devise:logout', (event, oldUser) ->
        $scope.currentUser = null
        $scope.isAuth = false

    null
]

m.controller 'AuthDialogCtrl', ['$scope', '$modalInstance', ($scope, dialog) ->
    @scope = $scope

    $scope.ok = -> dialog.close {email: $scope.email, password: $scope.password}
    $scope.cancel = -> dialog.dismiss 'cancel'

    null
]
