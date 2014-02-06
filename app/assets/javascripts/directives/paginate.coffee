'use strict'

angular.module('radioxideApp')
  .directive('paginate', () ->
    templateUrl: '/angular/paginate.html'
    restrict: 'E'
    scope:
      collection: '='
    link: (scope, element, attrs) ->
      scope.$watch 'collection', () ->
        if scope.collection
          scope.refreshCollection()
    controller: ($scope, $element, $attrs, $transclude, $route, $location) ->
      $scope.refreshCollection = () ->
        $scope.meta =  $scope.collection.meta

        if $scope.meta.current_page > 1
          $scope.previous = "#{$attrs.path}/#{$scope.meta.current_page - 1}"
        if $scope.meta.current_page < $scope.meta.total_page
          $scope.next = "#{$attrs.path}/#{$scope.meta.current_page + 1}"
  )
