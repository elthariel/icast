'use strict'

angular.module('icastApp')
  .controller 'AllGenresCtrl', ($scope, $http, Restangular) ->
    baseUrl = Restangular.configuration.baseUrl
    $http.get("#{baseUrl}/genres.json").success (data) ->
      $scope.genres = data.genres
      $scope.genres = _.map $scope.genres, (value, key) ->
        value.name = key
        value

      $scope.columns = [
        $scope.genres.slice(0, $scope.genres.length / 3)
        $scope.genres.slice($scope.genres.length / 3, 2 * $scope.genres.length / 3),
        $scope.genres.slice(2 * $scope.genres.length / 3, $scope.genres.length),
      ]


