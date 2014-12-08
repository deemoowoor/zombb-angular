angular.module 'zombbApp', ['zombb.auth', 'zombb.topic', 'zombb.user', 'ngRoute', 'ngSanitize']
    .config ['$routeProvider', ($routeProvider) ->
        $routeProvider
            .when '/topics',
                templateUrl: '/demo/topic-list.html'
                controller: 'TopicListCtrl'

            .when '/topics/new',
                templateUrl: '/demo/topic.html'
                controller: 'TopicNewCtrl'

            .when '/topics/:topic_id/edit',
                templateUrl: '/demo/topic.html'
                controller: 'TopicEditCtrl'

            .when '/topics/:topic_id',
                templateUrl: '/demo/topic.html'
                controller: 'TopicCtrl'

            .when '/users/:user_id',
                templateUrl: '/demo/user.html'
                controller: 'UserCtrl'

            .when '/users/:user_id/edit',
                templateUrl: '/demo/user.html'
                controller: 'UserEditCtrl'

            .when '/register',
                templateUrl: '/demo/user.html',
                controller: 'UserRegisterCtrl'

            .otherwise
                redirectTo: '/topics'
    ]
