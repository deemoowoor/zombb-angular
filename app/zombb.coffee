angular.module 'zombbApp', ['zombbControllers', 'ngRoute']
    .config ['$routeProvider', ($routeProvider) ->
        $routeProvider
            .when('/topics',
                templateUrl: '/demo/topic-list.html'
                controller: 'TopicListCtrl'
            )
            .when('/topics/:topic_id',
                templateUrl: '/demo/topic.html'
                controller: 'TopicCtrl'
            )
            .otherwise(
                redirectTo: '/topics'
            )
    ]
