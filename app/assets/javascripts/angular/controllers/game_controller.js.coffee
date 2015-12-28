@TfCardsApp.controller 'GameController', [ '$scope', 'gameParams', 'gameService', 'serverInterface', 'gameFactory', ( $scope, gameParams, gameService, serverInterface, gameFactory) ->
  $scope.test_text = "Hello world from angular"
  $scope.gameOptions = {backgroundColor: '#228b22'}

  $scope.dealCard = () =>
    $scope.enabled = false
    $scope.game.dealCard(180, 100).then () =>
      $scope.enabled = true

  $scope.dealtCards = () =>
    $scope.game.dealtCards

  $scope.enabled = false

  # this event starts the game once
  # the creativeCanvas directive initialises a creativeJSstage 
  # then we read a game from the server and enable the interface once it has loaded
  $scope.$on( 'creativeCanvas', (event, args) =>
    game_id = gameParams[0]
    serverInterfaceGames = new serverInterface('/api/games/', [], gameFactory)
    serverInterfaceGames.show(game_id).then( (game)=>
      $scope.game = game
      $scope.cards = game.cards
      $scope.enabled = true
    )
  )
]
