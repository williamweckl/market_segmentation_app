this.app.controller('SegmentsCtrl', ['$scope', '$rootScope', '$q', '$mdDialog', 'Segment', 'Index', function ($scope, $rootScope, $q, $mdDialog, Segment, Index) {
    /* Initialize variables with default values */
    $scope.segments = [];

    //close dialog
    $scope.close = function() {
        $mdDialog.hide();
    };

    /* Segments */

    //function to get segments from the API
    function getSegments() {
        //Create loading with promise to stop loading when the request is finished
        $scope.segmentsLoading = true;
        var loadingPromise = $q.defer();
        loadingPromise.promise.then(function() {
            $scope.segmentsLoading = false;
        });

        //configure Index service to get contacts
        var IndexConfig = {
            resource: Segment,
            loadingPromise: loadingPromise
        }

        //calling Index service and at the return add objects to list
        Index.do(IndexConfig).then(function(data) {
            $scope.segments = data;
        });
    };

    //Get positions
    getSegments();

    //filter by segment
    $scope.filterBySegment = function(segment) {
        var filterObject = {
            positionIds: segment.position_ids,
            states: segment.states,
        };

        //if age, fill the sliders with the age value
        if (segment.age) {
            filterObject.age = parseInt(segment.age);
            filterObject.startAge = parseInt(segment.age);
            filterObject.endAge = parseInt(segment.age);
        }

        if (segment.start_age)
            filterObject.startAge = parseInt(segment.start_age);

        if (segment.end_age)
            filterObject.endAge = parseInt(segment.end_age);

        //send broadcast to filter controller
        $rootScope.$broadcast('segment-selected', filterObject);
        //close dialog
        $scope.close();
    };
}]);