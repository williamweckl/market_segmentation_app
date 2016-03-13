this.app.controller('ContactsCtrl', ['$scope', '$rootScope', '$q', 'Contact', 'Index', function ($scope, $rootScope, $q, Contact, Index) {

    /* Initialize variables with default values */
    $scope.contacts = []; //contacts list array
    $scope.page = 1; //for pagination
    $scope.listVars = {end: false, loading: true, moreContactsloading: false}; //loadings and end of the list flags
    $scope.filterObject = {};

    /* Functions */
    //function to get contacts from the API
    function getContacts(loadingPromise, filterObject) {
        //if not getting more contacts, create the promise to resolve on finish and stop loading
        if (!loadingPromise) {
            $scope.listVars.loading = true;
            var loadingPromise = $q.defer();
            loadingPromise.promise.then(function () {
                $scope.listVars.loading = false;
            });
        }

        //params to send to the API
        var params = {
            page: $scope.page,
            per_page: 30,
        };

        //Filters
        if (filterObject) {
            if (filterObject.startAge && filterObject.endAge && filterObject.startAge == filterObject.endAge) {
                params.age = filterObject.startAge;
            } else {
                if (filterObject.startAge)
                    params.start_age = filterObject.startAge - 1; //subtract 1 to include the age selected
                if (filterObject.endAge)
                    params.end_age = filterObject.endAge + 1; //add 1 to include the age selected
            }
            if (filterObject.positionIds)
                params.position_ids = filterObject.positionIds;
            if (filterObject.save)
                params.save = true;
        }

        //configure Index service to get contacts
        var IndexConfig = {
            resource: Contact,
            params: params,
            listVars: $scope.listVars,
            loadingPromise: loadingPromise
        };

        //calling Index service and at the return add objects to list
        Index.do(IndexConfig).then(function (data) {
            //If page is the first, reset the list
            if ($scope.page == 1) {
                $scope.contacts = data;
            } else {
                $scope.contacts = $scope.contacts.concat(data);
            }
        });
    };

    //Get the first contacts
    getContacts();

    //function to get more contacts when the button is clicked
    $scope.getMoreContacts = function () {
        $scope.page += 1; //increment page

        //set loading and create a promise to stop loading at the end of the request
        $scope.listVars.moreContactsloading = true;
        var loadingPromise = $q.defer();
        loadingPromise.promise.then(function () {
            $scope.listVars.moreContactsloading = false;
        });

        //get the next contacts
        getContacts(loadingPromise, $scope.filterObject);
    };

    //Apply filters
    $scope.$on('contacts-filtered', function (event, filterObject, loadingPromise) {
        var element = angular.element(document.getElementById('content'));

        //animate scroll to the top
        if (!$rootScope.isEmpty(element)) element.scrollTop(0, 1000);
        //reset page
        $scope.page = 1;
        $scope.listVars.end = false;
        $scope.filterObject = filterObject;
        getContacts(loadingPromise, filterObject);
    });

}]);