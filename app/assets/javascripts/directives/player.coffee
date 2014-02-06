'use strict'

angular.module('radioxideApp')
  .directive 'player', (Player) ->
    templateUrl: '/angular/player.html'
    restrict: 'E',

    controller: ($scope, $element, $attrs, $transclude, $sce) ->
      $scope.isPlaying = false
      $scope.play = () ->
        console.log "Play !"
        $scope.isPlaying = true
        #$scope.playingUri = $sce.trustAsResourceUrl $scope.current.streams[0].uri
        $scope.playingUri = $sce.trustAsResourceUrl 'http://streaming202.radionomy.com:80/City-Dance-Radio'
        console.log $scope.playingUri
      $scope.stop = () ->
        console.log "Stop !"
        $scope.isPlaying = false
        $scope.playingUri = null
      $scope.restart = () ->
        $scope.stop()
        $scope.play()

    link: (scope, element, attrs) ->
      Player.setScope scope
      scope.$watch 'current', () ->
        if scope.current?
          scope.restart()
