m = angular.module 'zombbApp', ['zombb.auth', 'zombb.topic', 'zombb.user',
    'zombb.dashboard', 'ngRoute', 'ngSanitize']

m.config ['$routeProvider', '$provide', ($routeProvider, $provide) ->
    baseSrcPath = '/demo'
    $provide.value('baseSrcPath', baseSrcPath)
    $routeProvider
        .when '/topics',
            templateUrl: "#{baseSrcPath}/topic-list.html"
            controller: 'TopicListCtrl'

        .when '/topics/new',
            templateUrl: "#{baseSrcPath}/topic.html"
            controller: 'TopicNewCtrl'

        .when  '/topics/:topic_id/edit',
            templateUrl: "#{baseSrcPath}/topic.html"
            controller: 'TopicEditCtrl'

        .when '/topics/:topic_id',
            templateUrl: "#{baseSrcPath}/topic.html"
            controller: 'TopicCtrl'

        .when '/users/:user_id',
            templateUrl: "#{baseSrcPath}/user.html"
            controller: 'UserCtrl'

        .when '/users/:user_id/edit',
            templateUrl: "#{baseSrcPath}/user.html"
            controller: 'UserEditCtrl'

        .when '/register',
            templateUrl: "#{baseSrcPath}/user.html",
            controller: 'UserRegisterCtrl'

        .when '/dashboard',
            templateUrl: "#{baseSrcPath}/dashboard.html",
            controller: 'DashboardCtrl'

        .otherwise
            redirectTo: '/topics'
    null
]

m.controller 'NavCtrl', ['$scope', 'Auth', 'Authorize',
($scope, Auth, Authorize) ->

    $scope.Authorize = Authorize

    null
]
