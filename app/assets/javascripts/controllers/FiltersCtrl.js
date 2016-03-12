this.app.controller('FiltersCtrl', ['$scope', '$rootScope', function ($scope, $rootScope) {

    /* Initialize variables with default values */
    $scope.filterObject = {startAge: 16, endAge: 105};

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



}]);