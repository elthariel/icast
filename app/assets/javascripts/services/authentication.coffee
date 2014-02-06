'use strict'

angular.module('radioxideApp')
  .service 'Authentication',
    class Authentication
      constructor: ($rootScope, Restangular) ->
        console.log "Creating Authentication service."

        @baseUser = Restangular.all('user')
        @rootScope = $rootScope
        @refreshCurrentUser()

      refreshCurrentUser: () ->
        @rootScope.currentUser = @baseUser.one('sessions', 'current').get().$object




