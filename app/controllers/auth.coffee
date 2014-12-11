m = angular.module 'zombb.auth', ['ngResource', 'Devise', 'ui.bootstrap']

m.config ['AuthProvider', (AuthProvider) ->
    #AuthProvider.loginPath('http://localhost:3000/users/sign_in.json')
    #AuthProvider.logoutPath('http://localhost:3000/users/sign_out.json')
    null
]

m.config ['AuthInterceptProvider', (AuthInterceptProvider) ->
    AuthInterceptProvider.interceptAuth(true)
    null
]

m.run ['Auth', (Auth) ->
    # Restore authenticated state on startup
    Auth.login()
]


m.factory 'Authorize', ['Auth', (Auth) ->
    role =
        admin: 'admin'
        editor: 'editor'
        reader: 'reader'

    @condition =
        owner: (user) ->
            (user and Auth._currentUser?.name == user.name) or @admin()

        auth: ->
            Auth.isAuthenticated()

        admin: ->
            @auth() and Auth._currentUser?.role == role.admin

        editor: ->
            @auth() and (Auth._currentUser?.role == role.editor or @admin())

        reader: ->
            @auth() and (Auth._currentUser?.role == role.reader or @admin())

        editor_owner: (user) ->
            @editor() or @owner(user)

    this
]

m.controller 'AuthCtrl', ['$scope', '$modal', 'Auth', 'Authorize',
($scope, $modal, Auth, Authorize) ->

    $scope.Auth = Auth
    $scope.Authorize = Authorize

    $scope.templateUrl = 'zombbAuthCtrl.html'

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

        dialog.result.then doLogin
        dialog

    $scope.$on 'devise:unauthorized', (event, xhr, deferred) ->
        $scope.open().result
            .then(-> $http(xhr.config))
            .then((response) -> deferred.resolve(response))

    $scope.$on 'devise:login', (event, currentUser) ->
        $scope.currentUser = currentUser

    $scope.$on 'devise:logout', (event, oldUser) ->
        $scope.currentUser = null

    null
]

m.controller 'AuthDialogCtrl', ['$scope', '$modalInstance', ($scope, dialog) ->
    $scope.ok = -> dialog.close {email: $scope.email, password: $scope.password}
    $scope.cancel = -> dialog.dismiss 'cancel'
    null
]
