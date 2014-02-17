'use strict';

angular.module('icastApp')
  .controller 'LocalCtrl', ($scope, Restangular, Player, $routeParams) ->
    baseLocal = Restangular.all('stations').all('local')

    baseLocal.getList({page: $routeParams.page, page_size: 8}).then (radios) ->
      $scope.radios = radios

    $scope.play = (radio) ->
      Player.play(radio)
    $scope.details = (radio) ->
      $scope.currentRadioId = radio.id #Restangular.one('stations', id).get().$object



