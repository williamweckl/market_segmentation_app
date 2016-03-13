describe('ContactsCtrl', function() {
    var scope, rootScope, q, httpBackend, createController;

    beforeEach(module('segmentation'));

    beforeEach(inject(function($controller, $rootScope, $httpBackend, _$q_) {
        scope = $rootScope.$new();
        rootScope = $rootScope;
        q = _$q_;
        httpBackend = $httpBackend;

        createController = function() {
            return $controller('ContactsCtrl', {
                '$scope': scope
            });
        };
        scope.$digest();
    }));

    it('should set default values', function() {
        var controller = createController();
        expect(scope.contacts).toEqual([]);
        expect(scope.page).toEqual(1);
        expect(scope.listVars.end).toEqual(false);
        expect(scope.listVars.loading).toEqual(true);
        expect(scope.listVars.moreContactsloading).toEqual(false);
        expect(scope.filterObject).toEqual({});
    });

    describe('getContacts', function () {
        it('should get contacts from the API', function() {
            var contacts = [{"id":1,"name":"Felícia Moreira","email":"moreira.cia.fel@emmerichroberts.org","age":76,"state":{"id":4,"name":"Amazonas"},"position":{"id":23,"name":"human resources"}},{"id":2,"name":"Yuri Martins","email":"martins.yuri@langoshweimann.net","age":58,"state":{"id":11,"name":"Mato Grosso"},"position":{"id":21,"name":"interpreter"}}];

            httpBackend.expect('GET', '/contacts?page=1&per_page=30').respond(contacts);

            var controller = createController();
            httpBackend.flush();
            expect(scope.contacts.length).toEqual(contacts.length);
            expect(scope.listVars.end).toEqual(true);
            expect(scope.listVars.loading).toEqual(false);
            expect(scope.listVars.moreContactsloading).toEqual(false);
            expect(scope.filterObject).toEqual({});

            httpBackend.verifyNoOutstandingExpectation();
            httpBackend.verifyNoOutstandingRequest();
        });
        it('should aplly filters when filter broadcast is called', function() {
            var contacts = [{"id":1,"name":"Felícia Moreira","email":"moreira.cia.fel@emmerichroberts.org","age":30,"state":{"id":4,"name":"Amazonas"},"position":{"id":23,"name":"human resources"}},{"id":2,"name":"Yuri Martins","email":"martins.yuri@langoshweimann.net","age":30,"state":{"id":11,"name":"Mato Grosso"},"position":{"id":21,"name":"interpreter"}}];
            httpBackend.expect('GET', '/contacts?page=1&per_page=30').respond([]);
            var controller = createController();
            httpBackend.flush();

            var filterObject = {startAge: 30, endAge: 30};
            var loadingPromise = q.defer();

            httpBackend.expect('GET', '/contacts?age=30&page=1&per_page=30').respond(contacts);

            rootScope.$broadcast('contacts-filtered', filterObject, loadingPromise);
            httpBackend.flush();
            expect(scope.contacts.length).toEqual(contacts.length);
            expect(scope.listVars.end).toEqual(true);
            expect(scope.listVars.loading).toEqual(false);
            expect(scope.listVars.moreContactsloading).toEqual(false);
            expect(scope.filterObject).toEqual(filterObject);

            httpBackend.verifyNoOutstandingExpectation();
            httpBackend.verifyNoOutstandingRequest();
        });
    });
    describe('getMoreContacts', function () {
        it('should get next page contacts from the API', function() {
            var contactsPageOne = [{"id":1},{"id":2}];
            var contactsPageTwo = [{"id":3},{"id":4}];
            httpBackend.expect('GET', '/contacts?page=1&per_page=30').respond(contactsPageOne);

            var controller = createController();
            httpBackend.flush();
            expect(scope.page).toEqual(1);
            expect(scope.contacts.length).toEqual(2);

            httpBackend.expect('GET', '/contacts?page=2&per_page=30').respond(contactsPageTwo);
            scope.getMoreContacts();
            httpBackend.flush();
            expect(scope.page).toEqual(2);
            expect(scope.contacts.length).toEqual(4);

            httpBackend.verifyNoOutstandingExpectation();
            httpBackend.verifyNoOutstandingRequest();
        });
        it('should maintain filters when getting next page contacts from the API', function() {
            var contacts = [{"id":1},{"id":2}];
            var contactsPageTwo = [{"id":3},{"id":4}];
            httpBackend.expect('GET', '/contacts?page=1&per_page=30').respond([]);
            var controller = createController();
            httpBackend.flush();

            var filterObject = {startAge: 30, endAge: 30};
            var loadingPromise = q.defer();

            httpBackend.expect('GET', '/contacts?age=30&page=1&per_page=30').respond(contacts);

            rootScope.$broadcast('contacts-filtered', filterObject, loadingPromise);
            httpBackend.flush();
            expect(scope.contacts.length).toEqual(contacts.length);
            expect(scope.listVars.end).toEqual(true);
            expect(scope.listVars.loading).toEqual(false);
            expect(scope.listVars.moreContactsloading).toEqual(false);
            expect(scope.filterObject).toEqual(filterObject);

            httpBackend.expect('GET', '/contacts?age=30&page=2&per_page=30').respond(contactsPageTwo);
            scope.getMoreContacts();
            httpBackend.flush();
            expect(scope.page).toEqual(2);
            expect(scope.contacts.length).toEqual(4);

            httpBackend.verifyNoOutstandingExpectation();
            httpBackend.verifyNoOutstandingRequest();
        });
    });

});