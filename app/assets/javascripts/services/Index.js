this.app.service("Index", ['$rootScope', '$q', function ($rootScope, $q) {

    return {
        do: function (params) {
            var paramsToSend = {};

            return params.resource.get(paramsToSend).$promise.then(function (data) {
                return data;
            });
        }
    };

}]);