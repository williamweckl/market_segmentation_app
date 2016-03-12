this.app.factory("Position", ['$resource', function ($resource) {
    return $resource('/positions', {}, {
        get: {method: 'GET', isArray: true},
    });
}]);