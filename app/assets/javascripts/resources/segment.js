this.app.factory("Segment", ['$resource', function ($resource) {
    return $resource('/segments', {}, {
        get: {method: 'GET', isArray: true},
    });
}]);