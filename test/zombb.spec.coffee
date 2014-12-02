describe('zombb', ->
    beforeEach(module('zombbApp', 'ngResource', 'Devise', 'ui.bootstrap'))
    beforeEach(module('zombb.auth'))
    beforeEach(module('zombb.topic'))

    describe('AuthCtrl', ->
        $scope = null
        $compile = null
        Auth = null
        $controller = null
        $document = null
        $timeout = null

        beforeEach(inject((_$httpBackend_, _$document_, _$timeout_,
                            $rootScope, _$controller_, _Auth_) ->
            $httpBackend = _$httpBackend_
            $scope = $rootScope
            Auth = _Auth_
            $controller = _$controller_
            $document = _$document_
            $timeout = _$timeout_
        ))

        beforeEach(->
            @addMatchers({ toHaveModalsOpen: (numberOfModals) ->
                    modalDom = @actual.find('body > div.modal')
                    modalDom.length == numberOfModals
            }))

        # cleanup
        afterEach(->
            body = $document.find('body')
            body.find('div.modal').remove()
            body.find('div.modal-backdrop').remove()
            body.removeClass('modal-open')
        )

        createAuthController = (scope) ->
            ctrl = $controller('AuthCtrl', { $scope: scope})


        it('should be able to open a modal dialog and close it', inject(() ->
            ctrl = createAuthController($scope)

            $scope.templateUrl = ''
            $scope.template = '<div></div>'

            dialog = $scope.open()

            $scope.$digest()

            expect($document).toHaveModalsOpen(1)

            dialog.dismiss('cancel in test')
            $timeout.flush()

            $scope.$digest()

            expect($document).toHaveModalsOpen(0)

        ))

        it('should authenticate a user', inject(($controller) ->
            ctrl = createAuthController($scope)

            $scope.email = 'test@test.com'
            $scope.password = 'secret'

            $scope.templateUrl = ''
            $scope.template = '<div></div>'

            dialog = $scope.open()

            $scope.$digest()

            expect($document).toHaveModalsOpen(1)
            # TODO
        ))
    )
)
