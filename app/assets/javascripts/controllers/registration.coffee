'use strict'

angular.module('radioxideApp')
  .controller 'RegistrationCtrl', ($scope, Restangular, $location) ->
    $scope.register = () ->
      console.log $scope.user
      baseRegistration = Restangular.all('user').all('registrations')
      baseRegistration.post({ user_registration: $scope.user }).then () ->
        $scope.registered = true
