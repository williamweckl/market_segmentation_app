this.app.controller('AppCtrl', ['$scope', '$mdSidenav', function ($scope, $mdSidenav) {
    //Toggle filters sidenav
    $scope.toggleFilters = function() {
        $mdSidenav('filters')
            .toggle();
    };
    //Close filters sidenav
    $scope.closeFilters = function() {
        $mdSidenav('filters')
            .close();
    };
}]);