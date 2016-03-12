this.app.controller('AppCtrl', ['$scope', '$mdSidenav', function ($scope, $mdSidenav) {
    //Toggle filters sidenav
    $scope.toggleFilters = function() {
        $mdSidenav('filters')
            .toggle();
    };
}]);