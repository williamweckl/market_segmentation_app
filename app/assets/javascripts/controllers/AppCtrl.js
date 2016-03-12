this.app.controller('AppCtrl', ['$scope', '$rootScope', 'Contact', 'Index', function ($scope, $rootScope, Contact, Index) {

    $scope.contacts = [];

    //get contacts
    var IndexConfig = {
        resource: Contact,
    }
    Index.do(IndexConfig).then(function(data) {
        $scope.contacts = data;
    });

}]);