//Index service to handle API calls, results and errors
this.app.service("Index", ['$q', '$mdToast', function ($q, $mdToast) {

    return {
        //Call the api and handle the response
        do: function (params) {
            var paramsToSend = params.params || {}; //params to send to the API

            //Call the API through angular resources
            return params.resource.get(paramsToSend).$promise.then(function (data) {
                /* Success */

                //Verify if is the end of the list and set flag
                if (params.params && params.params.per_page && data.length < params.params.per_page)
                    params.listVars.end = true;

                //Resolve the promise to end loadings
                params.loadingPromise.resolve();

                //Return the response to controller
                return data;
            }, function(data) {
                /* Error */

                $mdToast.show(
                    $mdToast.simple()
                        .textContent('Ops, algo deu errado. Isso não deveria acontecer mas fique tranquilo, logo será resolvido.')
                        .hideDelay(3000)
                );

                //Resolve the promise to end loadings
                params.loadingPromise.resolve();

                //Return the response to controller
                return data;
            });
        }
    };

}]);