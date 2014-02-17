'use strict'

angular.module('icastApp')
  .directive 'radiothumb', () ->
    templateUrl: '/angular/radio_thumb.html'
    scope:
      radio: '=radio'
    restrict: 'E'
    link: (scope, element, attrs) ->
    controller: ($scope, $element, $attrs, $transclude, $parse, Player) ->
      $scope.imgClick = () ->
        if $attrs.imgClick
          $parse($attrs.imgClick)($scope.$parent.$parent, {radio: $scope.radio})
        else
          Player.play $scope.radio
      $scope.bodyClick = () ->
        if $attrs.bodyClick
          $parse($attrs.bodyClick)($scope.$parent.$parent, {radio: $scope.radio})

