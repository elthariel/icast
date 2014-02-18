'use strict';

angular.module('icastApp')
  .controller 'MainCtrl', ($scope, Restangular, Player) ->
    baseStation = Restangular.all('stations')
    baseStation.getList({page_size:1}).then (radios) ->
      $scope.stream_count = (radios.meta.total_count / 1000).toFixed() * 1000

    baseLocal = Restangular.all('stations').all('local')
    baseLocal.getList({page_size: 10}).then (radios) ->
      $scope.locals = radios

    basePopular = Restangular.all('genres').all('popular')
    basePopular.getList().then (genres) ->
      $scope.genres = _.shuffle(genres).slice(0, 15)


    $scope.play = (radio) ->
      Player.play(radio)
