this.app.service("Index", ['$rootScope', '$q', function ($rootScope, $q) {

    return {
        do: function (params) {
            var paramsToSend = params.params || {};

            return params.resource.get(paramsToSend).$promise.then(function (data) {
                params.loadingPromise.resolve();

                //Verify if is the end of the list
                if (data.length < params.params.per_page) params.listVars.end = true;

                return data;
            }, function(data) {
            //    TODO: ERROR
                params.loadingPromise.resolve();
                return data;
            });
        }
    };

}]);