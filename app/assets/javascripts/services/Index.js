//Index service to handle API calls, results and errors
this.app.service("Index", ['$q', function ($q) {

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

            //    TODO: ERROR handle

                //Resolve the promise to end loadings
                params.loadingPromise.resolve();

                //Return the response to controller
                return data;
            });
        }
    };

}]);