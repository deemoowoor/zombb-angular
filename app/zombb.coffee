angular.module 'zombbApp', ['zombb.auth', 'zombb.topic', 'ngRoute', 'ngSanitize']
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

            .otherwise
                redirectTo: '/topics'
    ]
