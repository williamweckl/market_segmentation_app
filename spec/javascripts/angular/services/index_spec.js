describe('Index service', function() {

    var mdToast, httpBackend, Index, Contact;

    beforeEach(module('segmentation'));

    beforeEach(inject(function($httpBackend, _Index_, _$q_, _$mdToast_, _Contact_) {
        mdToast = _$mdToast_;
        httpBackend = $httpBackend;
        Index = _Index_;
        Contact = _Contact_;
        q = _$q_;
    }));

    it('should handle success request', function() {
        var contacts = [{id: 1}];
        var resolved = false;
        httpBackend.expect('GET', '/contacts').respond(contacts);

        var params = {};
        var loadingPromise = q.defer();
        loadingPromise.promise.then(function() {
            resolved = true;
        });

        //configure Index service to get contacts
        var IndexConfig = {
            resource: Contact,
            params: params,
            listVars: {},
            loadingPromise: loadingPromise
        };

        //calling Index service and at the return add objects to list
        Index.do(IndexConfig);
        httpBackend.flush();

        expect(resolved).toEqual(true);

        httpBackend.verifyNoOutstandingExpectation();
        httpBackend.verifyNoOutstandingRequest();
    });

    it('should set end if results length is lesser than per_page', function() {
        var contacts = [{id: 1}];
        var listVars = {end: false};
        httpBackend.expect('GET', '/contacts?page=1&per_page=2').respond(contacts);

        var params = {page: 1, per_page: 2};
        var loadingPromise = q.defer();

        //configure Index service to get contacts
        var IndexConfig = {
            resource: Contact,
            params: params,
            listVars: listVars,
            loadingPromise: loadingPromise
        };

        //calling Index service and at the return add objects to list
        Index.do(IndexConfig);
        httpBackend.flush();

        expect(listVars.end).toEqual(true);

        httpBackend.verifyNoOutstandingExpectation();
        httpBackend.verifyNoOutstandingRequest();
    });

    it('should handle error request', function() {
        var resolved = false;
        httpBackend.expect('GET', '/contacts').respond(500);
        spyOn(mdToast, 'show').and.callThrough();

        var params = {};
        var loadingPromise = q.defer();
        loadingPromise.promise.then(function() {
            resolved = true;
        });

        //configure Index service to get contacts
        var IndexConfig = {
            resource: Contact,
            params: params,
            listVars: {},
            loadingPromise: loadingPromise
        };

        //calling Index service and at the return add objects to list
        Index.do(IndexConfig);
        httpBackend.flush();

        expect(resolved).toEqual(true);
        expect(mdToast.show).toHaveBeenCalled();

        httpBackend.verifyNoOutstandingExpectation();
        httpBackend.verifyNoOutstandingRequest();
    });

});