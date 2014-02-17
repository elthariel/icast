'use strict';

angular.module('icastApp')
  .controller 'MainCtrl', ($scope, Restangular, Player) ->
    baseLocal = Restangular.all('stations').all('local')
    baseLocal.getList({page_size: 10}).then (radios) ->
      $scope.locals = radios

    $scope.play = (radio) ->
      Player.play(radio)
