@TfCardsApp.directive 'creativeCanvas', [ '$timeout', 'gameService',  ($timeout, gameService) ->
  return {
  restrict: 'AE',
  scope: {
    options: '='
  },
  template: "<div class='creativeCanvas' style='position:relative'></div>",
  link: (scope, elm, attrs) ->
    # detect touch or mouse
    isTouch = !!('ontouchstart' in window)

    #set default options
    options = scope.options || {}

    options.width = options.width || 400
    options.height = options.height || 300
    options.id = options.id || 'creativeCanvas'

    options.backgroundColor = options.backgroundColor || 0xCCCCCC


    # create canvas and context
    canvas = document.createElement('canvas')
    canvas.id = options.id
    angular.element(canvas).css({
       position: 'absolute',
       top: 0,
       left: 0,
      'z-index': 0,
      'background-color': options.backgroundColor
    })

    canvas.backgroundColor = options.backgroundColor

    # add the canvas to the DOM
    elm.find('div').append(canvas)
    elm.css({
      'width': options.width,
      'height': options.height,
    })


    #set canvas size
    canvas.width = options.width
    canvas.height = options.height

    # create the createJS stage and initialise the gameService
    # emit an event to inform the application the stage is ready
    $( document ).ready( () =>
      $timeout( =>
        gameService.stageReady(new createjs.Stage(options.id))
        scope.$emit( 'creativeCanvas', {stageReady: true})
      ,0)
    )
  }
]

