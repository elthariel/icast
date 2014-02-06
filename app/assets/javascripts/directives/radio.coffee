'use strict'

angular.module('radioxideApp')
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
        Player.play($scope.radio)

      $rootScope.$watch 'currentUser', () ->
        $scope.currentUser = $rootScope.currentUser


