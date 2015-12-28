#= require ../../spec_helper.coffee

describe 'Game Factory', ->

  describe 'support functions for initialise/reset', ->

    # create a mock for the card factory
    beforeEach ->
      window.TfCardsApp.factory 'cardFactory', ($q) ->
        class cardFactory
          constructor: () ->
          setPosition: (options) ->
            @x = options.x
            @y = options.y
            @faceup = options.faceup
            @visible = options.visible
          setFlipside: (@bitmap) ->


    beforeEach inject (gameService, gameFactory, cardFactory) ->

      # get the game service and spy on it
      @gameService = gameService
      spyOn( @gameService, 'update').and.callFake () ->
      spyOn( @gameService, 'addChild').and.callFake (child) ->

      # create a game
      @game = new gameFactory()
      # set up some mock cards for the game
      @game.cards= [ new cardFactory(), new cardFactory()]

      @gameFactory = gameFactory


    it 'should create a game object', ->
      expect(@game instanceof  @gameFactory ).toBe(true);

    describe "resetting cards", () ->
      # tests the resetCards() method of gameFactory
      beforeEach () ->
        # set up some default values for the cards which are different to the cards initialisation values
        for card in @game.cards
           card.x = 1
           card.y = 2
           card.faceup = true
           card.visible = false
         # deal one card so we can test this vaulue is reset
        @game.dealtCards  = 1

        # reset the cards
        @game.resetCards()

      it "should have set the initial position of all the cards", () ->
        for card in @game.cards
          expect(card.x).toEqual 0
          expect(card.y).toEqual 0

      it "should have set the number of dealt cards to zero", () ->
         expect(@game.dealtCards).toEqual 0

      it "should have updated the stage", () ->
        expect(@gameService.update).toHaveBeenCalled()


    describe "it should make all the cards ready for use", ->
      # tests the cardDataReady() method of gameFactory

      beforeEach () ->
        # create a fake bitmap for the cards flipside
        @the_bitmap = 'the_bitmap'
        @game.bitmaps = {card_background: @the_bitmap}

        # mock the promise used returned when he cards are ready
        @game.deferred ={resolve: (param) -> param}

        @resolvedParam = @game.cardDataReady()

      it "should have set the flipside bitmap on all the cards", () ->
        for card in @game.cards
          expect(card.bitmap).toEqual @the_bitmap

      it "should have added all the cards to the stage", () ->
        expect(@gameService.addChild.calls.count()).toEqual @game.cards.length

      it "should return itself when the cards are ready", () ->
        expect(@resolvedParam).toBe @game


  describe 'initialise', ->
    # tests the initialise() method of gameFactory

    # create a mock of the server interface
    beforeEach ->
      window.TfCardsApp.factory 'serverInterface', ($q) ->
        class serverInterface
          constructor: (@url, @cards, cardModel) ->
          update: () ->
            a = 1
          all: () ->
            deferred = $q.defer()
            deferred.resolve()
            deferred.promise

    beforeEach inject ($rootScope, gameFactory)  ->
      @scope = $rootScope.$new()

      # create a game
      @game = new gameFactory()

    beforeEach (done)  ->

      # set the card background image to be loaded
      @options = {}
      @options.image_list = [ 'card_background']
      @options.image_manifest = [{src: '/assets/test/card.png', id: 'card_background'}]

      # initialise the game
      waitForAngular = new @waitForAngular(@scope, done)
      @game.initialise(@options).then () =>
        waitForAngular.done()



    it "should set up the cards array correctly", ->
      expect(@game.cards instanceof  Array ).toBe(true);
      expect(@game.cards.length).toBe 0

    it "should load the card flipside image", ->
      expect(@game.bitmaps.card_background instanceof  createjs.Bitmap ).toBe(true);

  describe 'dealing cards', ->
  # tests the dealCard() method of gameFactory

    # create a mock of the cardFactory
    beforeEach ->
      window.TfCardsApp.factory 'cardFactory', () ->
        class cardFactory
          constructor: () ->
            @flipped = false
          moveCard: (@x, @y, doFlip, callback) ->
            @flipped = !@flipped if doFlip
            callback(this)
          setPosition: (@x, @y, @flipped) ->

    beforeEach inject ($rootScope, gameService, gameFactory, cardFactory)  ->
      @scope = $rootScope.$new()

      # create a game
      @gameService = gameService
      spyOn(@gameService, 'setChildOnTop').and.callFake () ->
      spyOn(@gameService, 'update').and.callFake () ->

      @game = new gameFactory()

      # create some cards in the game
      @game.cards = [ new cardFactory(), new cardFactory(), new cardFactory()]

      # spy on a card in order to detect when it is reset
      @firstCard = @game.cards[0]
      spyOn(@firstCard, 'setPosition')


    it "should reset the cards if all the cards have been dealt", () ->
      @firstCard.setPosition.calls.reset()
      @game.dealtCards  = @game.cards.length
      @game.dealCard()
      expect( @firstCard.setPosition.calls.count()).toEqual 1

    it "should not call reset the cards if all the cards have not been dealt", () ->
      @firstCard.setPosition.calls.reset()
      @game.dealtCards  =  1
      @game.dealCard()
      expect( @firstCard.setPosition.calls.count()).toEqual 0

    it "should deal the first card", (done) ->
      @game.dealtCards  =  0
      cardToDeal = @game.cards[@game.dealtCards]
      waitForAngular = new @waitForAngular(@scope, done)
      @game.dealCard(0,0).then (card) =>
        expect(card).toBe cardToDeal
        expect(card.flipped).toBeTruthy()
        expect(@game.dealtCards).toEqual 1
        waitForAngular.done()

    it "should deal the correct card", (done) ->
      @game.dealtCards  =  1
      cardToDeal = @game.cards[@game.dealtCards]
      waitForAngular = new @waitForAngular(@scope, done)
      @game.dealCard(0,0).then (card) =>
        expect(card).toBe cardToDeal
        expect(card.flipped).toBeTruthy()
        expect(@game.dealtCards).toEqual 2
        waitForAngular.done()

    it "should deal all the cards and then reset the cards on the next deal", () ->
      @game.dealtCards  =  0
      @firstCard.setPosition.calls.reset()
      for card in @game.cards
        @game.dealCard()
      expect( @firstCard.setPosition.calls.count()).toEqual 0
      @game.dealCard()
      expect( @firstCard.setPosition.calls.count()).toEqual 1

    it "should set the dealt cards zorder and update the stage", () ->
      @game.dealtCards  =  0
      @gameService.update.calls.reset()
      for card in @game.cards
        @game.dealCard()
        lastCall = @gameService.setChildOnTop.calls.mostRecent()
        expect(lastCall.args[0]).toBe card
      expect(@gameService.update.calls.count()).toEqual @game.cards.length


