# common method to show error messages
# usually a flash diretive listens to the event
# and flashes an error
@TfCardsApp.service 'errorHandler', [ '$rootScope',
  class errorHandler
    constructor: (@$rootScope) ->

    process: (error) ->
      @$rootScope.$broadcast('flash', error)
]
