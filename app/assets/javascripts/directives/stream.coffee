'use strict'

angular.module('icastApp')
  .directive 'stream', (Player) ->
    templateUrl: '/angular/stream.html'
    restrict:    'E'
    scope:
      station:    '=station'
      stream:     '=stream'

    controller: ($scope, $element, $attrs, $transclude, $sce, Player) ->
      $scope.play = () ->
        Player.play($scope.station, $scope.stream)
      $scope.formatMime = () ->
        switch $scope.stream.mime
          when 'audio/mpeg'     then 'Mp3'
          when 'audio/vorbis'   then 'Ogg'
          when 'audio/aac'      then 'Aac'
          when 'audio/x-aac'    then 'Aac'
          when 'audio/mp4'      then 'Aac'
          else                  $scope.stream.mime

    link: (scope, element, attrs) ->
