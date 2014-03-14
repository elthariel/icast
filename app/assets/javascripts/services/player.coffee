'use strict'

angular.module('icastApp')
  .service 'Player',
    class Player
      constructor: ($rootScope) ->
        @rootScope = $rootScope
        @scope = @rootScope.$new(false)
        @current = null
        @ready = false

        soundManager.setup
          wmode:        'transparent'
          url:          '/swf'
          flashVersion: 9
          onready: () =>
            @ready = true

        @setDefaults()

      getScope: () ->
        @scope

      setDefaults: () ->
        @scope.radio        = {name: 'No stream playing'}
        @scope.playingText  =  'Click on a stream logo to start playing'
        @scope.playing      =      false

      selectPlayingUri: (stream) ->
        uri = stream.uri

        # This is a hack to disable Shoutcast status page generation
        if uri.match /:\d+$/
          uri = "#{uri}/;"

        uri

      play: (radio = null, stream = null) ->
        if radio
          @scope.radio = radio
          if stream
            @scope.stream = stream
          else if @scope.radio.streams
            @scope.stream = radio.streams[0]
          else
            return

        if @sound
          @stop()


        @scope.playingText = "Buffering..."
        @sound = soundManager.createSound
          url:      @selectPlayingUri(@scope.stream)
          volume:   50
          autoplay: true
          onid3: () ->
          onload: (success) =>
            if success
              @scope.playing = true
              @scope.playingText = 'Playing'
            else
              @scope.playing = false
              @scope.playingText = 'Unable to load stream (server is down or incompatibility issue'
            @rootScope.$digest()
        @sound.play()

      stop: () ->
        if @sound
          @sound.destruct()
          @sound = null
          @scope.playing = false
          @scope.playingText = "Stopped"
      restart: () ->
        @stop()
        @play()

Player.$inject = ['$rootScope']
