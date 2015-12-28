#= require ../../spec_helper.coffee

describe 'Game Service', ->
  # create a mock for the card factory
  beforeEach ->
    window.TfCardsApp.factory 'cardFactory', () ->
      class cardFactory extends createjs.Container
        constructor: (index) ->
          @name = index.toString()
          @zIndex = index

  beforeEach inject (gameService, cardFactory) ->
    # get the game service and spy on it
    @gameService = gameService
    @cardFactory = cardFactory


  it ('should have a stageReady function'), ->
     expect(@gameService.stageReady).toBeTruthy()

  it ('should have an update function'), ->
    expect(@gameService.update).toBeTruthy()

  it ('should have an addChild function'), ->
    expect(@gameService.addChild).toBeTruthy()

  it ('should set a child to the top of the zOrder'), ->
    # create canvas and context
    canvas = document.createElement('canvas')
    canvas.id = 'canvasId'
    @gameService.stageReady(new createjs.Stage('canvasId'))

    # create some cards
    @gameService.addChild(new @cardFactory(i)) for i in [1..3]

    # expect the cards to be displayed
    # with the first one created at the bottom
    # and the last one created at the top

    #bottom
    expect(@gameService.stage.getChildAt(0).name).toEqual '1'
    #middle
    expect(@gameService.stage.getChildAt(1).name).toEqual '2'
    #top
    expect(@gameService.stage.getChildAt(2).name).toEqual '3'

    # move the bottom card to the top
    @gameService.setChildOnTop(@gameService.stage.getChildAt(0))

    #bottom
    expect(@gameService.stage.getChildAt(0).name).toEqual '2'
    #middle
    expect(@gameService.stage.getChildAt(1).name).toEqual '3'
    #top
    expect(@gameService.stage.getChildAt(2).name).toEqual '1'
