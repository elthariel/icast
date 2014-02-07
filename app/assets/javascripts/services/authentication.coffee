'use strict'

angular.module('icastApp')
  .service 'Authentication',
    class Authentication
      constructor: ($rootScope, Restangular) ->

        @baseUser = Restangular.all('user')
        @rootScope = $rootScope
        @refreshCurrentUser()

      refreshCurrentUser: () ->
        @rootScope.currentUser = @baseUser.one('sessions', 'current').get().$object

Authentication.$inject = ['$rootScope', 'Restangular']




