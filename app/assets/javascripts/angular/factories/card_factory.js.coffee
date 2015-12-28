@TfCardsApp.factory 'cardFactory', ['$q', 'gameService', ($q, gameService) ->
  # a card is a createJS container
  # a card holds all data relevent to the card which
  # includes the images on the front and back of the card
  # and any game info/game properties of the card
  # gameService provides accesse to the createJS stage

  class cardFactory extends createjs.Container
    constructor: () ->
      super()

    # the method is called to initialise the cards images and data
    # it returns a promise which is resolved when all the cards images are loaded
    initialise: (options) =>
      @deferred = $q.defer()

      # set the cards initial position
      @set({x: options.x || 0, y: options.y || 0, visible: !options.visible? || options.visible, faceup: !!options.faceup});

      @zIndex = 0

      # use a createJS preloader to load teh images
      @queue = new createjs.LoadQueue(true);
      @queue.on("complete", @imagesLoaded);
      @queue.loadManifest(options.image_manifest);

      #this controls the zOrder of the cards images
      @image_order = options.image_order

      return @deferred.promise

    # this method is a callback from teh creaeJS preloaded
    # and is called when all the cards images are loaded
    # it looks in @imageOrder for thw image names and the
    # order in which the names appear in this array is the zorder of the images
    imagesLoaded: () =>
      for key in @image_order
        bitmap = new createjs.Bitmap( @queue.getResult(key));
        @addChild(bitmap);

      # we don't need the preloader or the imageOrder anymore
      @image_order = null
      @queue = null
      # resolve the promise created in teh initialise mthod to show that the card is loaded
      @deferred.resolve(this)

    # set the image for the card background,
    # this is just loaded once by the the cards parent rather than by every card
    # this method copies the background image and adds it to the card
    setFlipside: (background) ->
      # copy the image
      @flipside = new createjs.Bitmap(background.image);

      # add the flipside image to the cards bitmaps
      @addChild(@flipside)

      # default the cards faceup status
      @flipside.set({visible: false})
      @faceup = false
      @show_side(@faceup)


    # sets either the cards images or the cards flipside visible
    show_side: (front) =>
      for child in @children
        child.set(visible: front)
      @flipside.set({visible: !front})

    # sets the cards position
    setPosition: (options) =>
      # this is the createJS container method
      @set(options)
      # allow faceup status to be set in the options parameter
      @faceup =  !!options.faceup
      @show_side(@faceup)

    # tween the card to its new location
    # flipping it if flip is set to true
    # and calling the moveComplete callback when the tween has finished
    moveCard: (x,y, flip, moveComplete) =>
      @startFlip() if flip
      createjs.Tween.get(this)
      .to({ scaleX: 0, x: x/2.0, y: y/2.0, flippingStatus: 1 }, 1000, createjs.Ease.getPowIn(4))
      .to({ scaleX: 1 , x: x, y: y }, 1000, createjs.Ease.getPowOut(2))
      .call( moveComplete, [this] )
      .addEventListener('change', @flipper)



    # set the flipping status to 0
    # this is incremented during a flip
    # when it reaches 0.9 then a flip occurs
    # and flipping set to false
    startFlip: ->
      @flippingStatus = 0
      @flipping = true
      
    # change the cards faceup status
    # and reset the flippingStatus and flipping variables
    # so that another tweening flip doesn't occur
    # until startFlip is called again
    flip: () ->
      @faceup = !@faceup
      @show_side(@faceup)
      @flipping = false
      @flippingStatus = 0

    # call whilst tweening
    # increment flippingStatus and
    # flip  the card once it reaches 0.9
    flipper: (event) =>
      gameService.update()
      if @flipping && @flippingStatus > 0.9
        @flip()

]