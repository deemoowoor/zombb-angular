m = angular.module 'zombb.user', ['ngResource', 'zombb.auth', 'zombb.util']

m.factory 'User', ['$resource', ($resource) ->
    ($resource '/users/:user_id.json', {user_id: '@id'})
]

m.controller 'UserCtrl', ['$scope', '$routeParams', 'User', ($scope, $routeParams, User) ->
    @scope = $scope

    User.get {user_id: $routeParams.user_id }, (user) ->
        $scope.user = user
]

m.controller 'UserEditCtrl', ['$scope', '$routeParams', '$location', '$http', 'Auth',
'ConfirmDialog', 'User',
($scope, $routeParams, $location, $http, Auth, ConfirmDialog, User) ->
    $scope.editmode = true

    $scope.error = null

    User.get { user_id: $routeParams.user_id } , (user) ->
        $scope.user = user

    $scope.submit = ->
        successcb = (user) ->
            User.get { user_id: $scope.user.id } , (user) ->
                $scope.user = user
                $location.path '/users/' + $scope.user.id

        $http.put('/users.json', {user: $scope.user.toJSON()})
            .success(successcb)
            .error((error) -> $scope.error = error.data)

    $scope.cancel = ->
        $location.path '/users/' + $scope.user.id

    $scope.deleteAccount = ->
        dialog = ConfirmDialog($scope, { title: "Confirm cancel account?" })
        doDelete = (rest) ->
            $http.delete('/users.json', {user: $scope.user.toJSON()})
            Auth.logout()
            $location.path '/'
        dialog.result.then doDelete, ((error) -> $scope.error = error)
    null
]

m.controller 'UserRegisterCtrl', ['$scope', '$routeParams', '$location', 'Auth',
($scope, $routeParams, $location, Auth) ->
    $scope.editmode = true
    $scope.register = true
    $scope.user = {name: ''}

    $scope.submit = ->
        Auth.register($scope.user).then ((user) -> $location.path '/users/' + user.id),
                (error) -> $scope.error = error.data.errors
    null
]
