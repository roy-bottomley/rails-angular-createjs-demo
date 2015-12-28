#= require spec_helper.coffee

describe 'Creative Directive', ->

  beforeEach () ->
    renderedCanvas= (util, customEqualityTesters) ->
      {
      compare: (element, options) ->

        canvas = element.find('canvas')[0]

        result = {}
        result.pass =  true

        if !canvas?
          result.pass = false
          msg = "Expected element to contain a canvas but it did not. "
        else
          msg = ''
          for key, value of options
            if canvas[key] != value
              result.pass = false
              msg += "Expected canvas #{key} to be #{options[key]} but it was #{canvas[key]}."

        if result.pass
          result.message = "Canvas rendered correctly"
        else
          result.message = msg

        result
      }

    jasmine.addMatchers({renderedCanvas: renderedCanvas})

  beforeEach () ->
    @createDirective = (options) ->
      @scope.options = options
      @compile("<creative-canvas options='options'></creative-canvas>") @scope


  beforeEach  inject ($rootScope, $compile, gameService) ->
    @scope = $rootScope.$new()
    @compile = $compile

    @gameService = gameService
    spyOn(@gameService, 'stageReady')


  it "should render a default canvas correctly", ->
    options = {id: 'creativeCanvas', width: 400, height: 300, backgroundColor: 0xCCCCCC}
    expect(@createDirective()).renderedCanvas(options)

  it "should render a canvas with the correct options", ->
    options = {id: 'testId', width: 44, height: 33, backgroundColor: 0xFF}
    expect(@createDirective(options)).renderedCanvas(options)


