'use strict'

angular.module('radioxideApp')
  .controller 'GenreCtrl', ($scope, $routeParams, Restangular) ->
    ra = Restangular.all('stations').all("genre/#{$routeParams.genre}")
    ra.getList({page: $routeParams.page}).then (radios) ->
      $scope.radios = radios

    $scope.genre = $routeParams.genre

    $scope.selectRadio = (id) ->
      $scope.currentRadioId = id

