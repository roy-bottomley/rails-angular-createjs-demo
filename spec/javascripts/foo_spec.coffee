#= require spec_helper.coffee

describe 'something', ->

  beforeEach () ->
    @createDirective = (options) ->
      @scope.options = options
      @compile("<creative-canvas options='options'></creative-canvas>") @scope

  beforeEach  inject ($rootScope, $compile, gameService) ->
    @scope = $rootScope.$new()
    @compile = $compile
    element = @createDirective()
    canvas = element.find('#creativeCanvas')[0]
    data = canvas.getContext('2d').getImageData(10, 10, 1, 1).data
    a = 1



  it "should work", ->
    expect(1).toEqual 1



