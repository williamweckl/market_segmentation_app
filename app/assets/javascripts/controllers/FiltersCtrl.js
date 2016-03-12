this.app.controller('FiltersCtrl', ['$scope', '$rootScope', '$q', 'Position', 'Index', function ($scope, $rootScope, $q, Position, Index) {

    /* Initialize variables with default values */
    $scope.filterObject = {startAge: 16, endAge: 105};
    $scope.positionSearch = {name: ''}
    $scope.positions = [];

    /* Don't allow startAge be hight than endAge */

    var initializingStartAge = true;
    $scope.$watch('filterObject.startAge', function(newValue, oldValue) {
        if (!initializingStartAge) {
            if (newValue > $scope.filterObject.endAge) {
                $scope.filterObject.startAge = $scope.filterObject.endAge;
            }
        }
        initializingStartAge = false;
    });

    var initializingEndAge = true;
    $scope.$watch('filterObject.endAge', function(newValue, oldValue) {
        if (!initializingEndAge) {
            if (newValue < $scope.filterObject.startAge) {
                $scope.filterObject.endAge = $scope.filterObject.startAge;
            }
        }
        initializingEndAge = false;
    });

    /* Positions */

    //function to get positions from the API
    function getPositions() {
        //Create loading with promise to stop loading when the request is finished
        $scope.positionsLoading = true;
        var loadingPromise = $q.defer();
        loadingPromise.promise.then(function() {
            $scope.positionsLoading = false;
        });

        //configure Index service to get contacts
        var IndexConfig = {
            resource: Position,
            loadingPromise: loadingPromise
        }

        //calling Index service and at the return add objects to list
        Index.do(IndexConfig).then(function(data) {
            $scope.positions = $scope.positions.concat(data);
        });
    };

    //Get positions
    getPositions();

    /* Filter */

    $scope.filter = function() {
        //Create loading with promise to stop loading when the request is finished
        $scope.filterObject.loading = true;
        var loadingPromise = $q.defer();
        loadingPromise.promise.then(function() {
            $scope.filterObject.loading = false;
        });

        //Get selected positions
        $scope.filterObject.positionIds = [];
        angular.forEach($scope.positions, function(position) {
            if (position.selected)
                $scope.filterObject.positionIds.push(position.id);
        });
        $scope.filterObject.positionIds = $scope.filterObject.positionIds.join();

        //Send broadcast to contacts controller
        $rootScope.$broadcast('contacts-filtered', $scope.filterObject, loadingPromise);
    };

}]);