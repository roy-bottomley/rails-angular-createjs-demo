#= require application
#= require angular-mocks

# used to ensure angular promises are run correctly
# these schedule code to be run which needs $apply
# to be run to the scheduled code
beforeEach ->
  class @waitForAngular
    constructor: (scope, done) ->
      @finished = false
      wait = (scope, done) =>
        scope.$apply() # force angular to cycle
        if @finished
          done()
        else
          setTimeout( =>
            wait(scope, done)
          , 100)
      wait(scope, done)

    done: () ->
      @finished = true


beforeEach(module('TfCardsApp'))


beforeEach ->
  @gameParamsMock = [
    {id : 1}
    ]
