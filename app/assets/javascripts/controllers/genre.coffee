'use strict'

angular.module('icastApp')
  .controller 'GenreCtrl', ($scope, $routeParams, Restangular, Player) ->
    ra = Restangular.all('stations').all("genre/#{$routeParams.genre}")
    ra.getList({page: $routeParams.page, page_size: 8}).then (radios) ->
      $scope.radios = radios

    $scope.genre = $routeParams.genre

    $scope.details = (radio) ->
      $scope.currentRadioId = radio.id
    $scope.play = (radio) ->
      Player.play(radio)

