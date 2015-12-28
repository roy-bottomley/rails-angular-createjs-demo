@TfCardsApp.factory 'gameFactory', ['$q', 'serverInterface', 'gameService',  'cardFactory', ($q, serverInterface, gameService, cardFactory) ->
  class gameFactory
    constructor: () ->
    # a game holds all the playing objects in a game
    # and contains the logic to manipulate them
    # the options here and passed from a Rails model and contain

    # serverInterface provides accesse to teh Rails server the createJS stage
    # gameService provides accesse to the createJS stage
    # cardFactoryprovides card models

    # this method is passed information to create the gamme
    # in this case a list of cards and a background image for the cards.
    # it returns a promise which is resolved when the game is loaded
    initialise: (options) =>
      gameService = gameService

      # the cards used in the game
      @cards = []
      # an interface to the server to read and write the cards
      @serverInterfaceCards = new serverInterface("/api/games/#{options.id}/cards/", @cards, cardFactory)

      # holder for any bitmaps, such as card reverse side image
      @bitmaps = {}
      # the promise to return
      @deferred = $q.defer()


      # use the createJs preloaded to load any images
      @queue = new createjs.LoadQueue(true);
      @queue.on("complete", @imagesLoaded);
      @queue.loadManifest(options.image_manifest);

      # a mapping between the names in the image manifest and
      # game functions for the images
      @image_list = options.image_list

      return @deferred.promise

    # called by the CreateJS preloader when images for the game have been loaded
    # creates bitmaps for these images and then loads all the cards
    # note cards images are loaded seperately by each card.
    imagesLoaded: () =>
      # create bitsmaps for the images
      for key in @image_list
        @bitmaps[key] = new createjs.Bitmap( @queue.getResult(key));

      # finished with these objects so release them
      @image_list = null
      @queue = null

      # load all the cards
      @serverInterfaceCards.all().then( () =>
        @cardDataReady()
      )

    # called by the server interface when all the cards have been loaded
    # creates bitmaps for these images and then loads all the cards
    # adds the cards to the screen abd sets the reverse side image of each card
    # then resolves teh promise to show the game is loaded
    cardDataReady: () =>
      for card in @cards
        # set cards reverse side image
        card.setFlipside(@bitmaps.card_background);
        # add card to the screen
        gameService.addChild(card);

      @dealtCards = 0;

      @deferred.resolve(this)

    # set all the cards position and faceup status
    # set the number of dealt cards to 0
    # and refresh the screen
    resetCards: () =>
      for card in @cards
        card.setPosition({ x:0, y:0, faceup: false, visible: true});
      @dealtCards = 0;
      gameService.update();

    # return the bitmap for a cards reverse side
    getCardFlipside: () =>
      @bitmaps.card_background

    # move a card and flip it
    # if all cards have been dealt reset the cards first
    dealCard: (x, y) =>
      if @dealtCards >= @cards.length
        @resetCards()
      # get the card to deal
      card = @cards[@dealtCards]
      @dealtCards += 1
      # make this cards ZOrder to be the highest
      gameService.setChildOnTop(card)
      gameService.update();
      # move and flip the card

      @deferred = $q.defer()
      card.moveCard(x, y, true, @moveComplete);
      return @deferred.promise


    # callback after card has been dealt
    moveComplete: (card) =>
      @deferred.resolve(card)




]
