describe('AppCtrl', function () {

    var scope, rootScope, mdSidenav;

    beforeEach(function () {
        module('segmentation', function($provide) {
            mdSidenav = {};
            mdSidenav.toggle = jasmine.createSpy();
            mdSidenav.close = jasmine.createSpy();
            $provide.factory('$mdSidenav', function() {
                return function(direction){//if you use direction ('left' in your example) you could use it here
                    return mdSidenav;
                };
            })
        });
        inject(function ($controller, $rootScope) {
            scope = $rootScope.$new();
            rootScope = $rootScope;

            createController = function () {
                return $controller('AppCtrl', {
                    '$scope': scope
                });
            };
            scope.$digest();
        });
    });

    describe('filters side nav', function () {
        it('should toggle filters', function () {
            var controller = createController();
            scope.toggleFilters();
            expect(mdSidenav.toggle).toHaveBeenCalled();
        });
        it('should close filters', function () {
            var controller = createController();
            scope.closeFilters();
            expect(mdSidenav.close).toHaveBeenCalled();
        });
    });

});