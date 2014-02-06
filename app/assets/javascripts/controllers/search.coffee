'use strict'

angular.module('radioxideApp')
  .controller 'SearchCtrl', ($scope, Restangular, $routeParams, $timeout, $location) ->

    $scope.selectRadio = (id) ->
      $scope.currentRadioId = id #Restangular.one('stations', id).get().$object

    $scope.search = () ->
      baseSearch = Restangular.all('stations').all('search')
      params =
        q:    "#{$scope.query}*"
        page: $routeParams.page

      baseSearch.getList(params).then (radios) ->
        $scope.radios = radios

    if $routeParams.query
      $scope.query = $routeParams.query
      $scope.search()


    ######################################
    # Navbar search submit and auto-submit
    $scope.timeout = null
    cTimeout = (delay, fn) ->
      $timeout(fn, delay)
    $scope.submit = () ->
      console.log "Submit"
      $location.path("/search/#{$scope.navbarQuery}")

    $scope.$watch 'navbarQuery', () ->
      if $scope.navbarQuery and $scope.navbarQuery != $scope.query
        if $scope.timeout
          $timeout.cancel($scope.timeout)
          $scope.timeout = null
        $scope.timeout = cTimeout 1000, () ->
          $scope.submit()

