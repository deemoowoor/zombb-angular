m = angular.module 'zombb.util', ['ui.bootstrap']

m.factory 'ConfirmDialog', ['$modal', ($modal) ->
    ($scope, messages) ->
        $scope.templateUrl = null
        $scope.title = messages?.title or 'Confirm?'
        $scope.template = '<div class="modal-header">
            <h3 class="modal-title">{{ title }}</h3>
        </div>
        <div class="modal-body">
            <input type="submit" value="OK" class="btn btn-success" ng-click="ok()" />
            <button class="btn btn-default" ng-click="cancel()">Cancel</button>
        </div>'

        dialog = $modal.open
            templateUrl: $scope.templateUrl
            template: $scope.template
            controller: 'ConfirmDialogCtrl'
            controllerAs: 'confirmDialog'
            scope: $scope
]

m.controller 'ConfirmDialogCtrl', ['$scope', '$modalInstance', ($scope, dialog) ->
    $scope.ok = -> dialog.close true
    $scope.cancel = -> dialog.dismiss 'cancel'
    null
]
