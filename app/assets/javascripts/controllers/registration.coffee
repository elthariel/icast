'use strict'

angular.module('icastApp')
  .controller 'RegistrationCtrl', ($scope, Restangular, $location) ->
    $scope.register = () ->
      baseRegistration = Restangular.all('user').all('registrations')
      baseRegistration.post({ user_registration: $scope.user }).then () ->
        $scope.registered = true
