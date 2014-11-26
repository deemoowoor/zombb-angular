m = angular.module 'zombbControllers', ['ngResource']

m.factory 'Post', ['$resource', ($resource) -> $resource '/posts/:id']
m.factory 'PostComment', ['$resource', ($resource) -> $resource '/post_comments/:id']
m.factory 'User', ['$resource', ($resource) -> $resource '/users/:id']

m.controller 'TopicListCtrl', ['$scope', '$window', ($scope, $window) -> ]

m.controller 'TopicCtrl', ['$scope', '$window', ($scope, $window) -> ]
