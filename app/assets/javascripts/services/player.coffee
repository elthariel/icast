'use strict'

angular.module('icastApp')
  .service 'Player',
    class Player
      constructor: () ->
        @current = null
      play: (radio) ->
        if @scope
          @scope.current = radio
      setScope: (scope) ->
        @scope = scope

