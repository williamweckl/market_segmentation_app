describe('SegmentsCtrl', function() {

    var scope, rootScope, q, httpBackend, createController;

    beforeEach(module('segmentation'));

    beforeEach(inject(function($controller, $rootScope, $httpBackend, _$q_) {
        scope = $rootScope.$new();
        rootScope = $rootScope;
        q = _$q_;
        httpBackend = $httpBackend;
        spyOn(rootScope, '$broadcast');

        createController = function() {
            return $controller('SegmentsCtrl', {
                '$scope': scope
            });
        };
        scope.$digest();
    }));

    it('should set default values', function() {
        var controller = createController();
        expect(scope.segments).toEqual([]);
    });

    describe('getSegments', function () {
        it('should get segments from the API', function() {
            var segments = [{"id":1},{'id': 2}];

            httpBackend.expect('GET', '/segments').respond(segments);

            var controller = createController();
            httpBackend.flush();
            expect(scope.segments.length).toEqual(segments.length);

            httpBackend.verifyNoOutstandingExpectation();
            httpBackend.verifyNoOutstandingRequest();
        });
    });
    describe('filterBySegment', function () {
        it('should send segment-selected broadcast', function() {
            var controller = createController();

            var segment = { position_ids: '1,2,3', age: '30', start_age: '30', end_age: '30' };

            scope.filterBySegment(segment);
            expect(rootScope.$broadcast).toHaveBeenCalledWith('segment-selected', { positionIds: '1,2,3', age: 30, startAge: 30, endAge: 30 });
        });
    });
});