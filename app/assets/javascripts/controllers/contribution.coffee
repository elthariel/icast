'use strict'

angular.module('radioxideApp')
  .controller 'ContributionCtrl', ($scope, Restangular, $routeParams, $location) ->
    id = $routeParams.id
    Restangular.one('stations', id).get().then (station) ->
      station.genres = station.genre_list.join(', ')
      delete station.genre_list
      $scope.station = station

    $scope.setLogo = (file) ->
      reader = new FileReader
      reader.onloadend = () ->
        matches = reader.result.match(/^data:([a-z\/]+);base64,(.+)$/)
        $scope.base64Logo =
          filename:     file.name
          content_type: matches[1]
          base64:       matches[2]
      reader.readAsDataURL(file)

    $scope.submit = () ->
      # Cloning our station so we can prepare it for submission
      api_station = $scope.station.clone()

      # Wraps objects to objects_attributes
      for own key, value of api_station
        if value and typeof value  == 'object'
          delete api_station[key]
          api_station["#{key}_attributes"] = value

      # Transforming back 'genres' to an array
      api_station.genre_list = api_station.genres.split(',')
      delete api_station.genres

      if $scope.base64Logo and $scope.base64Logo.base64
        api_station.base64_logo = $scope.base64Logo

      api_station.post('suggest', { station: api_station }).then () ->
        $location.path('/')


