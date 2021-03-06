this.app.controller('FiltersCtrl', ['$scope', '$rootScope', '$q', '$mdDialog', '$mdMedia', 'Position', 'State', 'Index', function ($scope, $rootScope, $q, $mdDialog, $mdMedia, Position, State, Index) {

    /* Initialize variables with default values */
    $scope.filterObject = {startAge: 16, endAge: 105};
    $scope.positionSearch = {name: ''}
    $scope.positions = [];
    $scope.states = [];

    /* Don't allow startAge be higher than endAge */

    var initializingStartAge = true;
    $scope.$watch('filterObject.startAge', function (newValue, oldValue) {
        if (!initializingStartAge) {
            if (newValue > $scope.filterObject.endAge) {
                $scope.filterObject.startAge = $scope.filterObject.endAge;
            }
        }
        initializingStartAge = false;
    });

    var initializingEndAge = true;
    $scope.$watch('filterObject.endAge', function (newValue, oldValue) {
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
        loadingPromise.promise.then(function () {
            $scope.positionsLoading = false;
        });

        //configure Index service to get contacts
        var IndexConfig = {
            resource: Position,
            loadingPromise: loadingPromise
        }

        //calling Index service and at the return add objects to list
        Index.do(IndexConfig).then(function (data) {
            $scope.positions = data;
        });
    };

    //Get positions
    getPositions();

    //function to get states from the API
    function getStates() {
        //Create loading with promise to stop loading when the request is finished
        $scope.statesLoading = true;
        var loadingPromise = $q.defer();
        loadingPromise.promise.then(function () {
            $scope.statesLoading = false;
        });

        //configure Index service to get contacts
        var IndexConfig = {
            resource: State,
            loadingPromise: loadingPromise
        }

        //calling Index service and at the return add objects to list
        Index.do(IndexConfig).then(function (data) {
            $scope.states = data;
        });
    };

    //Get positions
    getStates();

    /* Filter */

    $scope.filter = function () {
        //Create loading with promise to stop loading when the request is finished
        $scope.filterObject.loading = true;
        var loadingPromise = $q.defer();
        loadingPromise.promise.then(function () {
            $scope.filterObject.loading = false;
        });

        //Get selected positions
        $scope.filterObject.positionIds = [];
        angular.forEach($scope.positions, function (position) {
            if (position.selected)
                $scope.filterObject.positionIds.push(position.id);
        });
        $scope.filterObject.positionIds = $scope.filterObject.positionIds.join();

        //Get selected states
        $scope.filterObject.states = [];
        angular.forEach($scope.states, function (state) {
            if (state.selected)
                $scope.filterObject.states.push(state.id);
        });
        $scope.filterObject.states = $scope.filterObject.states.join();

        //Send broadcast to contacts controller
        $rootScope.$broadcast('contacts-filtered', $scope.filterObject, loadingPromise);
    };

    //open dialog to list segments
    $scope.segmentsDialog = function () {
        var useFullScreen = ($mdMedia('sm') || $mdMedia('xs')) && $scope.customFullscreen
        $mdDialog.show({
            controller: 'SegmentsCtrl',
            templateUrl: 'segments_dialog',
            //parent: angular.element(document.body),
            clickOutsideToClose: true,
            fullscreen: useFullScreen
        });
        $scope.$watch(function () {
            return $mdMedia('xs') || $mdMedia('sm');
        }, function (wantsFullScreen) {
            $scope.customFullscreen = (wantsFullScreen === true);
        });
    };

    $scope.$on('segment-selected', function (event, filterObject) {
        $scope.filterObject = filterObject;
        angular.forEach($scope.positions, function (position) {
            if (filterObject.positionIds && filterObject.positionIds.indexOf(position.id.toString()) > -1) {
                position.selected = true;
            } else {
                position.selected = false;
            }
        });
        angular.forEach($scope.states, function (state) {
            if (filterObject.states && filterObject.states.indexOf(state.id.toString()) > -1) {
                state.selected = true;
            } else {
                state.selected = false;
            }
        });
        $scope.filter();
    });

}]);