angular.module 'zombbApp', ['zombbControllers']
    .factory 'Post', ($resource) -> $resource '/posts/:id'
    .factory 'PostComment', ($resource) -> $resource '/post_comments/:id'
    .factory 'User', ($resource) -> $resource '/users/:id'
    .config ['$routeProvider', ($routeProvider) ->
        $routeProvider
            .when('/topics',
                templateUrl: '/pages/topic-list.html'
                controller: 'TopicListCtrl'
            )
            .when('/topics/:topic_id',
                templateUrl: '/pages/topic.html'
                controller: 'TopicCtrl'
            )
            .otherwise(
                redirectTo: '/topics'
            )
    ]
