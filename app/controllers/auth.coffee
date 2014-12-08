m = angular.module 'zombb.auth', ['ngResource', 'Devise', 'ui.bootstrap']

m.config ['AuthProvider', (AuthProvider) ->
    #AuthProvider.loginPath('http://localhost:3000/users/sign_in.json')
    #AuthProvider.logoutPath('http://localhost:3000/users/sign_out.json')
]

# TODO: use interceptAuth to intercept 401 responses and display login dialog automatically

m.run ['Auth', (Auth) ->
    # Restore authenticated state on startup
    Auth.login()
]

m.controller 'AuthCtrl', ['$scope', '$modal', 'Auth', ($scope, $modal, Auth) ->
    @scope = $scope

    $scope.logOut = -> Auth.logout()

    $scope.templateUrl = 'zombbAuthCtrl.html'
    $scope.template = null

    $scope.open = (size) ->
        dialog = $modal.open
            templateUrl: $scope.templateUrl
            template: $scope.template
            controller: 'AuthDialogCtrl'
            controllerAs: 'authDialog'
            scope: $scope
            size: size

        doLogin = (credentials) ->
            Auth.login(credentials).then (->), (error) ->
                $scope.open()
                $scope.error = error.data.error

        dialog.result.then(doLogin, (error) -> $scope.error = error)
        dialog

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
