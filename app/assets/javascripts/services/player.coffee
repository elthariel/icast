'use strict'

angular.module('icastApp')
  .service 'Player',
    class Player
      constructor: () ->
        console.log "Creating Player service"
        @current = null
      play: (radio) ->
        if @scope
          @scope.current = radio
      setScope: (scope) ->
        @scope = scope

