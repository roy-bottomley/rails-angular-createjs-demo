#= require spec_helper.coffee

describe 'Card Factory', ->

  describe 'initialising', ->
    beforeEach inject ($rootScope, cardFactory) ->
      @scope = $rootScope.$new()

      @cardFactoryObject = cardFactory
      @card = new cardFactory


    it 'should create a card object', ->
      expect(@card instanceof  @cardFactoryObject ).toBe(true);

    it 'should load card images', (done) ->
      options = {}
      options.image_order = [ 'background']
      options.image_manifest = [{src: '/assets/test/card.png', id: 'background'}]

      expect(@card.children.length).toEqual(0);

      waitForAngular = new @waitForAngular(@scope, done)

      @card.initialise(options).then () =>
        c = @card
        expect(@card.children.length).toEqual(1);
        expect(@card.visible).toBeTruthy();
        expect(@card.faceup).not.toBeTruthy();
        waitForAngular.done()


    it 'should set a cards flipside', () ->
      bitmap = new createjs.Bitmap('/assets/test/flipped.png');
      expect(@card.children.length).toEqual(0);
      @card.setFlipside(bitmap)
      expect(@card.children.length).toEqual(1);
      expect(@card.faceup).toBe(false);

  describe 'flipping', ->
    beforeEach inject ($rootScope, gameService, cardFactory) ->

      @scope = $rootScope.$new()

      @gameService = gameService

      # create canvas and context
      canvas = document.createElement('canvas')
      canvas.id = 'canvasId'

      @gameService.stageReady(new createjs.Stage('canvasId'))

      # create a card
      @card = new cardFactory()

    beforeEach (done) ->
      options = {}
      options.image_order = [ 'background']
      options.image_manifest = [{src: '/assets/test/card.png', id: 'background'}]

      bitmap = new createjs.Bitmap('/assets/test/flipped.png');

      waitForAngular = new @waitForAngular(@scope, done)

      @card.initialise(options).then () =>
        @card.setFlipside(bitmap)
        waitForAngular.finished = true

    beforeEach () ->
      checkFaceupStatus= (util, customEqualityTesters) ->
        {
          compare: (card, faceupDescription) ->

            faceup = faceupDescription == 'faceup'

            result = {}
            result.pass = true
            result.message = "Expected faceup status correct";

            if card.faceup != faceup
              result.pass = false
              result.message = "Expected faceup to be #{faceup} and it was #{card.faceup}. "
            else
              visibleWord = {true: 'visible', false: 'hidden'}
              for bitmap in card.children
                if bitmap == card.flipside
                  if bitmap.visible == faceup
                    result.pass = false
                    result.message = "Expected flipside image to be #{visibleWord[!faceup]} and it was #{visibleWord[faceup]}. "
                    break
                else
                  if bitmap.visible != faceup
                    result.pass  = false
                    result.message = "Expected flipside image to be #{visibleWord[faceup]} and it was #{visibleWord[!faceup]}. "
                    break
            result
      }

      jasmine.addMatchers({checkFaceupStatus: checkFaceupStatus});

    it 'should have a frontside and flipside', ->
      expect(@card.children.length).toEqual(2);

    it 'should have the correct images visible status when faceup', ->
      expect(@card).checkFaceupStatus('facedown')

    it 'should have the correct images visible status when faceup', ->
      @card.flip()
      expect(@card).checkFaceupStatus('faceup')

    it 'should have the correct images visible status when flipped twice', ->
      @card.flip()
      @card.flip()
      expect(@card).checkFaceupStatus('facedown')

    it 'should not flip when flipper called and flipping status is less than 0.9', ->
      @card.startFlip()
      @card.flippingStatus = 0.5
      @card.flipper({})
      expect(@card).checkFaceupStatus('facedown')

    it 'should  flip when flipper called and flipping status is greater than 0.9', ->
      @card.startFlip()
      @card.flippingStatus = 0.95
      @card.flipper({})
      expect(@card).checkFaceupStatus('faceup')

    it 'should  flip when flipper called and flipping status is greater than 0.9 and it starts faceup', ->
      @card.flip()
      @card.startFlip()
      @card.flippingStatus = 0.95
      @card.flipper({})
      expect(@card).checkFaceupStatus('facedown')

    it 'should flip when tweened with flip set to true', (done)->
      @card.moveCard(10, 10, true, (card) =>
        expect(card).checkFaceupStatus('faceup')
        done()
      )

    it 'should not flip when tweened with flip set to false', (done)->
      @card.moveCard(0, 0, false, (card) =>
        expect(card).checkFaceupStatus('facedown')
        done()
      )


  describe 'moving', ->
    beforeEach inject ($rootScope, gameService) ->
      @scope = $rootScope.$new()
      @gameService = gameService

      # create canvas and context
      canvas = document.createElement('canvas')
      canvas.id = 'canvasId'

      @gameService.stageReady(new createjs.Stage('canvasId'))

    beforeEach inject (cardFactory) ->
      @cardFactoryObject = cardFactory
      @card = new cardFactory()

    beforeEach (done) ->
      @options = {x: 11, y: 27}
      @options.image_order = [ 'background']
      @options.image_manifest = [{src: '/assets/test/card.png', id: 'background'}]
      bitmap = new createjs.Bitmap('/assets/test/flipped.png');

      waitForAngular = new @waitForAngular(@scope, done)
      @card.initialise(@options).then () =>
        @card.setFlipside(bitmap)
        waitForAngular.done()

    it 'should start at the initialised position', ->
      expect(@card.x).toEqual(@options.x)
      expect(@card.y).toEqual(@options.y)


    it 'should move to a new position', (done)->
      newX = 101
      newY = 57
      @card.moveCard(newX, newY, true, () =>
        expect(@card.x).toEqual(newX)
        expect(@card.y).toEqual(newY)
        done()
      )
