this.app.controller('ContactsCtrl', ['$scope', '$rootScope', '$q', 'Contact', 'Index', function ($scope, $rootScope, $q, Contact, Index) {

    /* Initialize variables with default values */
    $scope.contacts = []; //contacts list array
    $scope.page = 1; //for pagination
    $scope.listVars = {end: false, loading: true, moreContactsloading: false}; //loadings and end of the list flags

    /* Functions */
    //function to get contacts from the API
    function getContacts(loadingPromise) {
        //if not getting more contacts, create the promise to resolve on finish and stop loading
        if (!loadingPromise) {
            $scope.listVars.loading = true;
            var loadingPromise = $q.defer();
            loadingPromise.promise.then(function() {
                $scope.listVars.loading = false;
            });
        }

        //params to send to the API
        var params = {
            page: $scope.page,
            per_page: 30,
        };

        //configure Index service to get contacts
        var IndexConfig = {
            resource: Contact,
            params: params,
            listVars: $scope.listVars,
            loadingPromise: loadingPromise
        }

        //calling Index service and at the return add objects to list
        Index.do(IndexConfig).then(function(data) {
            $scope.contacts = $scope.contacts.concat(data);
        });
    };

    //Get the first contacts
    getContacts();

    //function to get more contacts when the button is clicked
    $scope.getMoreContacts = function() {
        $scope.page += 1; //increment page

        //set loading and create a promise to stop loading at the end of the request
        $scope.listVars.moreContactsloading = true;
        var loadingPromise = $q.defer();
        loadingPromise.promise.then(function() {
            $scope.listVars.moreContactsloading = false;
        });

        //get the next contacts
        getContacts(loadingPromise);
    };

}]);