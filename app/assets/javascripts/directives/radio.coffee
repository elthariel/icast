'use strict'

angular.module('icastApp')
  .directive 'radio', () ->
    templateUrl: '/angular/radio.html'
    scope:
      id: '=radio'
    restrict: 'E'
    link: (scope, element, attrs) ->
      scope.$watch 'id', () ->
        if scope.id?
          scope.updateRadio()
    controller: ($scope, $element, $attrs, $transclude, Restangular, Player, $rootScope) ->
      $scope.updateRadio = () ->
        $scope.radio = Restangular.one('stations', $scope.id).get().$object
      $scope.play = () ->
        Player.play($scope.radio, $scope.radio.stream[0])

      $rootScope.$watch 'currentUser', () ->
        $scope.currentUser = $rootScope.currentUser


