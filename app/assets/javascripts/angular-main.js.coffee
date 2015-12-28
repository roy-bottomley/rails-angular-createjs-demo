@TfCardsApp = angular.module('TfCardsApp', ['ngResource'])
@TfCardsApp.run  [ "$rootScope", "$location", "$rootElement", ($rootScope, $location, $rootElement) ->
  $rootElement.off('click')
]

@TfCardsApp.config ($httpProvider, $locationProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
  $locationProvider.html5Mode(true)


