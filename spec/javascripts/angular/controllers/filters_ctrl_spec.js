describe('FiltersCtrl', function() {

    var scope, rootScope, q, mdDialog, httpBackend, createController;

    beforeEach(module('segmentation'));

    beforeEach(inject(function($controller, $rootScope, $httpBackend, _$q_, _$mdDialog_) {
        scope = $rootScope.$new();
        rootScope = $rootScope;
        q = _$q_;
        mdDialog = _$mdDialog_;
        httpBackend = $httpBackend;

        createController = function() {
            return $controller('FiltersCtrl', {
                '$scope': scope
            });
        };
        scope.$digest();
    }));

    it('should set default values', function() {
        var controller = createController();
        expect(scope.positions).toEqual([]);
        expect(scope.states).toEqual([]);
        expect(scope.filterObject.startAge).toEqual(16);
        expect(scope.filterObject.endAge).toEqual(105);
        expect(scope.positionSearch.name).toEqual('');
    });

    describe('ages watchers', function() {
        it('should not allow startAge to be higher than endAge', function() {
            httpBackend.expect('GET', '/positions').respond([]);
            httpBackend.expect('GET', '/states').respond([]);

            var controller = createController();
            scope.filterObject.endAge = 50;
            scope.$apply();
            scope.filterObject.startAge = 51;
            scope.$apply();

            expect(scope.filterObject.startAge).toEqual(50);
        });
        it('should not allow endAge to be lesser than startAge', function() {
            httpBackend.expect('GET', '/positions').respond([]);
            httpBackend.expect('GET', '/states').respond([]);

            var controller = createController();
            scope.filterObject.startAge = 51;
            scope.$apply();
            scope.filterObject.endAge = 50;
            scope.$apply();

            expect(scope.filterObject.endAge).toEqual(51);
        });
    });

    describe('getPositions', function () {
        it('should get positions from the API', function() {
            var positions = [{"id":1},{'id': 2}];

            httpBackend.expect('GET', '/positions').respond(positions);
            httpBackend.expect('GET', '/states').respond(positions);

            var controller = createController();
            httpBackend.flush();
            expect(scope.positions.length).toEqual(positions.length);

            httpBackend.verifyNoOutstandingExpectation();
            httpBackend.verifyNoOutstandingRequest();
        });
    });

    describe('getStates', function () {
        it('should get states from the API', function() {
            var states = [{"id":1},{'id': 2}];

            httpBackend.expect('GET', '/positions').respond(states);
            httpBackend.expect('GET', '/states').respond(states);

            var controller = createController();
            httpBackend.flush();
            expect(scope.states.length).toEqual(states.length);

            httpBackend.verifyNoOutstandingExpectation();
            httpBackend.verifyNoOutstandingRequest();
        });
    });

    describe('filter', function () {
        it('should send contacts-filtered broadcast', function() {
            httpBackend.expect('GET', '/positions').respond([]);
            httpBackend.expect('GET', '/states').respond([]);
            var controller = createController();
            spyOn(rootScope, '$broadcast');

            scope.filter();
            expect(rootScope.$broadcast).toHaveBeenCalled();
        });
    });

    describe('segmentsDialog', function () {
        it('should open dialog', function() {
            httpBackend.expect('GET', '/positions').respond([]);
            httpBackend.expect('GET', '/states').respond([]);
            var controller = createController();
            spyOn(mdDialog, 'show').and.callThrough();
            scope.segmentsDialog();
            expect(mdDialog.show).toHaveBeenCalled();
        });
    });

    describe('segment-selected broadcast', function () {
        it('should call filter', function() {
            httpBackend.expect('GET', '/positions').respond([]);
            httpBackend.expect('GET', '/states').respond([]);
            var controller = createController();
            var filterObject = {age: 30};
            spyOn(scope, 'filter').and.callThrough();
            rootScope.$broadcast('segment-selected', filterObject);
            expect(scope.filter).toHaveBeenCalled();
        });
        it('should select positions', function() {
            httpBackend.expect('GET', '/positions').respond([{id: 1}, {id: 2}, {id: 3}, {id: 4}]);
            httpBackend.expect('GET', '/states').respond([]);
            var controller = createController();
            httpBackend.flush();

            var filterObject = {positionIds: '1,2,3'};
            rootScope.$broadcast('segment-selected', filterObject);

            angular.forEach(scope.positions, function(position) {
                if ([1,2,3].indexOf(position.id) > -1) {
                    expect(position.selected).toEqual(true);
                } else {
                    expect(position.selected).toEqual(false);
                }
            });

            httpBackend.verifyNoOutstandingExpectation();
            httpBackend.verifyNoOutstandingRequest();
        });
        it('should select states', function() {
            httpBackend.expect('GET', '/positions').respond([]);
            httpBackend.expect('GET', '/states').respond([{id: 1}, {id: 2}, {id: 3}, {id: 4}]);
            var controller = createController();
            httpBackend.flush();

            var filterObject = {states: '1,2,3'};
            rootScope.$broadcast('segment-selected', filterObject);

            angular.forEach(scope.states, function(state) {
                if ([1,2,3].indexOf(state.id) > -1) {
                    expect(state.selected).toEqual(true);
                } else {
                    expect(state.selected).toEqual(false);
                }
            });

            httpBackend.verifyNoOutstandingExpectation();
            httpBackend.verifyNoOutstandingRequest();
        });
    });

});