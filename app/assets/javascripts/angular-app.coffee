'use strict';

module = angular.module('icastApp', ['ngCookies', 'ngResource', 'ngSanitize', 'ngRoute', 'restangular', 'mgcrea.ngStrap'])
module.config ($routeProvider, RestangularProvider, $locationProvider) ->
  # Configuring Restangular
  apiBaseUrl = "http://api.#{window.location.host}/1"
  RestangularProvider.setBaseUrl(apiBaseUrl)
  RestangularProvider.setRequestSuffix('.json')
  RestangularProvider.setDefaultHttpFields({withCredentials: true})

  RestangularProvider.addResponseInterceptor (data, op, what, url, resp, def) ->
    if op == 'getList' or op == 'get'
      if data.meta
        meta = data.meta
        delete data.meta
      res = data[Object.keys(data)[0]]
      res.meta = meta if meta
      res


  $locationProvider.html5Mode(true)

  # Our application routes
  $routeProvider.when '/',
    templateUrl: '/angular/main.html',
    controller:  'MainCtrl'
  .when '/search/:query?/:page?',
    templateUrl: '/angular/search.html',
    controller:  'SearchCtrl'
  .when '/local/:page?',
    templateUrl: '/angular/local.html',
    controller:  'LocalCtrl'
  .when '/genres',
    templateUrl: '/angular/genres.html',
    controller:  'AllGenresCtrl'
  .when '/genres/:genre/:page?',
    templateUrl: '/angular/genre.html',
    controller:  'GenreCtrl'
  .when '/contribute/:id',
    templateUrl: '/angular/contrib.html',
    controller: 'ContributionCtrl'
  .when '/signin',
    templateUrl: '/angular/signin.html',
    controller:  'SessionCtrl'
  .when '/signup',
    templateUrl: '/angular/signup.html',
    controller:  'RegistrationCtrl'
  .otherwise
    redirectTo: '/'

