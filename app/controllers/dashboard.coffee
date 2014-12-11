m = angular.module 'zombb.dashboard', ['zombb.auth', 'zombb.util']

m.controller 'DashboardCtrl', ['$scope', '$http', '$location', 'Authorize', 'ConfirmDialog',
($scope, $http, $location, Authorize, ConfirmDialog) ->

    unless Authorize.condition.admin()
        $location '/'

    $http.get('/stats.json')
        .success((data) -> $scope.stats = data)
        .error((error) -> $scope.error = error.data)

    $http.get('/users.json')
        .success((data) -> $scope.users = data)
        .error((error) -> $scope.error = error.data)

    $scope.getRoleIcon = (user) ->
        icons =
            admin: 'cogs'
            reader: 'eye'
            editor: 'edit'

        icons[user.role]

    $scope.getRoleColor = (user) ->
        colors =
            admin: 'danger'
            editor: 'warning'
            reader: 'success'

        colors[user.role]

    $scope.deleteUser = (user) ->
        dialog = ConfirmDialog($scope, { title: "Confirm cancel account?" })

        doDelete = (rest) ->
            $http.delete("/users/#{user.id}.json")
                .error((error) -> $scope.error = error.data)

        dialog.result.then doDelete

]
