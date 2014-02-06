'use strict'

angular.module('icastApp')
  .controller 'AllGenresCtrl', ($scope, $http, Restangular) ->
    baseUrl = Restangular.configuration.baseUrl
    $http.get("#{baseUrl}/genres.json").success (data) ->
      $scope.genres = data.genres



