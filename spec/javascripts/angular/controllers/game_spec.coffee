#= require ../../spec_helper.coffee

describe 'Game Controller', ->

  beforeEach inject ($rootScope, $controller, $q) ->
    @rootScope = $rootScope
    @scope = $rootScope.$new()

    class gameFactory
      constructor: () ->
        @dealtCards = 0
      dealCard: () ->
        @dealtCards += 1
        deferred = $q.defer()
        deferred.resolve('card dealt')
        return deferred.promise
      dealtCards: () ->
        @dealtCards


    class serverInterface
      constructor: (url, list, @factory) ->
      show: () ->
        deferred = $q.defer()
        deferred.resolve( new @factory)
        return deferred.promise

    @controller = $controller('GameController', { $scope: @scope, gameParams: @gameParamsMock, serverInterface:  serverInterface, gameFactory: gameFactory})

  it 'should not be enabled', ->
    expect(@scope.enabled).toBe(false);

  it 'should be enabled when after the creativeCanvas event has fired ',  ->
    @rootScope.$broadcast('creativeCanvas', {});
    # ensure the creativeCanvas event is processed by the controller
    @scope.$apply()

    expect(@scope.enabled).toBe(true);

  it 'should deal a card',  ->
    @rootScope.$broadcast('creativeCanvas', {});
    # ensure the creativeCanvas event is processed by the controller
    @scope.$apply()

    @scope.dealCard()
    expect(@scope.dealtCards()).toEqual 1


