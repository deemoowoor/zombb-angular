describe('zombb', ->
    beforeEach(module('zombbApp', 'zombb.auth', 'zombb.topic',
        'ngRoute', 'ngSanitize', 'ui.bootstrap'))
    beforeEach(module('zombb.auth', 'ngResource'))
    beforeEach(module('zombb.topic', 'ngResource'))

    AuthProvider = null
    beforeEach module('Devise', (_AuthProvider_) ->
        AuthProvider = _AuthProvider_
        null)

    describe('AuthCtrl', ->
        $scope = null
        $compile = null
        $controller = null
        $document = null
        $timeout = null
        $httpBackend = null
        Auth = null

        beforeEach(inject((_$httpBackend_, _$document_, _$timeout_,
                            $rootScope, _$controller_, _Auth_) ->
            $httpBackend = _$httpBackend_
            $scope = $rootScope
            $controller = _$controller_
            $document = _$document_
            $timeout = _$timeout_
            Auth = _Auth_
        ))

        beforeEach ->
            @addMatchers(
                toHaveModalsOpen: (numberOfModals) ->
                    modalDom = @actual.find('body > div.modal')
                    modalDom.length == numberOfModals
            )

        # cleanup
        afterEach ->
            body = $document.find('body')
            body.find('div.modal').remove()
            body.find('div.modal-backdrop').remove()
            body.removeClass('modal-open')
            $httpBackend.verifyNoOutstandingExpectation()
            $httpBackend.verifyNoOutstandingRequest()

        createAuthController = (scope) ->
            $controller('AuthCtrl', { $scope: scope})


        it('should be able to open a modal dialog and close it', inject(() ->
            ctrl = createAuthController($scope)

            $httpBackend.expectPOST('/users/sign_in.json').respond({})

            $scope.templateUrl = ''
            $scope.template = '<div></div>'

            dialog = $scope.open()

            $scope.$digest()

            expect($document).toHaveModalsOpen(1)

            dialog.dismiss('cancel in test')

            $timeout.flush()
            $httpBackend.flush()

            $scope.$digest()

            expect($document).toHaveModalsOpen(0)

        ))

        it('should authenticate a user', inject(($controller) ->
            ctrl = createAuthController($scope)

            expect(Auth.isAuthenticated()).toBe(false)

            $httpBackend.expectPOST('/users/sign_in.json').respond
                name: 'test'
                email: 'test@test.com'
                role: 'admin'

            $scope.email = 'test@test.com'
            $scope.password = 'secret'

            $scope.templateUrl = ''
            $scope.template = '<div></div>'

            dialog = $scope.open()

            dialog.close
                email: 'test@test.com'
                password: 'secret'

            $timeout.flush()
            $scope.$apply()
            $httpBackend.flush()

            $scope.$digest()

            expect(Auth.isAuthenticated()).toBe(true)
            expect(Auth._currentUser.role).toBe('admin')

        ))
    )
)
