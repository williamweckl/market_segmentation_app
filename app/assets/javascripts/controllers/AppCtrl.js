this.app.controller('AppCtrl', ['$scope', '$mdSidenav', function ($scope, $mdSidenav) {
    //Toggle filters sidenav
    $scope.toggleFilters = function() {
        console.log('toggleFilters');

        $mdSidenav('filters')
            .toggle();
    };
    //Close filters sidenav
    $scope.closeFilters = function() {
        console.log('close');

        $mdSidenav('filters')
            .close();
    };
}]);