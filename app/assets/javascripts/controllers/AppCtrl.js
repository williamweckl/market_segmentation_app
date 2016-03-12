this.app.controller('AppCtrl', ['$scope', '$rootScope', 'Contact', 'Index', function ($scope, $rootScope, Contact, Index) {

    //get contacts
    var IndexConfig = {
        resource: Contact
    }
    Index.do(IndexConfig).then(function() {

    });

}]);