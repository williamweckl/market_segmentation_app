this.app.controller('AppCtrl', ['$scope', '$rootScope', '$q', 'Contact', 'Index', function ($scope, $rootScope, $q, Contact, Index) {

    $scope.contacts = [];
    $scope.page = 1;
    $scope.listVars = {end: false, loading: true, moreContactsloading: false};

    function getContacts(loadingPromise) {
        if (!loadingPromise) {
            $scope.listVars.loading = true;

            var loadingPromise = $q.defer();

            loadingPromise.promise.then(function() {
                $scope.listVars.loading = false;
            });
        }

        var params = {
            page: $scope.page,
            per_page: 30,
        };

        //get contacts
        var IndexConfig = {
            resource: Contact,
            params: params,
            listVars: $scope.listVars,
            loadingPromise: loadingPromise
        }
        Index.do(IndexConfig).then(function(data) {
            if ($scope.page == 1) {
                $scope.contacts = data;
            } else {
                $scope.contacts = $scope.contacts.concat(data);
            }
        });
    };

    getContacts();

    $scope.getMoreContacts = function() {
        $scope.page += 1;
        $scope.listVars.moreContactsloading = true;

        var loadingPromise = $q.defer();

        loadingPromise.promise.then(function() {
            $scope.listVars.moreContactsloading = false;
        });

        getContacts(loadingPromise);
    };


}]);