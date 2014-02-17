'use strict'

angular.module('icastApp')
  .directive 'player', (Player) ->
    templateUrl: '/angular/player.html'
    restrict: 'E',

    controller: ($scope, $element, $attrs, $transclude, $sce) ->
      $scope.isPlaying = false
      $scope.play = () ->
        #$scope.playingUri = $sce.trustAsResourceUrl $scope.current.streams[0].uri
        #$scope.playingUri = $sce.trustAsResourceUrl 'http://streaming202.radionomy.com:80/City-Dance-Radio'
        Player.play()
      $scope.stop = () ->
        Player.stop()

    link: (scope, element, attrs) ->
      scope.player = Player.getScope()
