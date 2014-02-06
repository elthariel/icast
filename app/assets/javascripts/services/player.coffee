'use strict'

angular.module('radioxideApp')
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

