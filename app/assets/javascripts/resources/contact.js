this.app.factory("Contact", ['$resource', function ($resource) {
    return $resource('/contacts', {}, {
        get: {method: 'GET', isArray: true},
    });
}]);