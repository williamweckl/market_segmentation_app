this.app.factory("State", ['$resource', function ($resource) {
    return $resource('/states', {}, {
        get: {method: 'GET', isArray: true},
    });
}]);