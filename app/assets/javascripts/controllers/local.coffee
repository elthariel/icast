'use strict';

angular.module('radioxideApp')
  .controller 'LocalCtrl', ($scope, Restangular, Player, $routeParams) ->
    baseLocal = Restangular.all('stations').all('local')

    baseLocal.getList({page: $routeParams.page}).then (radios) ->
      $scope.radios = radios

    $scope.selectRadio = (id) ->
      $scope.currentRadioId = id #Restangular.one('stations', id).get().$object



