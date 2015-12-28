# my standard inerface between raisl and angular
@TfCardsApp.factory 'serverInterface', [ '$http', '$resource', '$q', 'errorHandler',  ($http, $resource, $q, errorHandler) ->
  class serverInterface

    removeIdFromList= (id, list) ->
      for item, index in list
        break if item.id == id
      list.splice index, 1  if list[index].id == id

    constructor: (url, @list, @modelFactory = null)->
      @service = $resource("#{url}:id",
        {id: '@id'},
        {update: {method: 'PATCH'}})

      defaults = $http.defaults.headers
      defaults.patch = defaults.patch || {}
      defaults.patch['Content-Type'] = 'application/json'

    create: (object) ->
      deferred = $q.defer()
      new @service(model: object).$save ((data) =>
        if !data?
          errorHandler.process("Server Error please try later")
        else if data.valid
          @list.push(data)
          deferred.resolve(data)
        else
          errorHandler.process(data.errors)
       )

      return deferred.promise

    delete: (object) ->
      if @list.indexOf(object) >= 0
        new @service().$delete {id: object.id}, ( ()=>
          index = @list.indexOf(object)
          @list.splice index, 1
          )

    update: (object) ->
      deferred = $q.defer()
      new @service(model: object).$update {id: object.id}, ( (data) =>
        if !data?
          errorHandler.process("Server Error please try later")
        else if data.valid
          index = @list.indexOf(object)
          removeIdFromList data.id, @list
          @list.push(data)
          deferred.resolve(data)
        else
          errorHandler.process(data.errors)
        )

      return deferred.promise

    show: (id) ->
      deferred = $q.defer()
      new @service().$get {id: id}, ((data) =>
        if data?
          @constructModel(data).then( (constructedModel) =>
            deferred.resolve(constructedModel)
          )
        else
          errorHandler.process("Server Error please try later")
      )
      return deferred.promise

    all: (parent) ->
      deferred = $q.defer()
      @service.query(parent_id: parent).$promise.then( (data) =>
        if data?
          for model in @list
            @list.pop()
          for model in data
            @constructModel(model).then( (constructedModel) =>
              @list.push(constructedModel)
              if @list.length == data.length
                deferred.resolve(@list)
            )
        else
          errorHandler.process("Server Error please try later")
      )
      return deferred.promise

    # return a promise form here so that the model.initialise method
    # can itself return a promise if it needs to (eg it may need to load an image)
    constructModel: (data) ->
      deferred = $q.defer()
      if @modelFactory?
        model = new @modelFactory()
        model.initialise(data).then( ()=>
          deferred.resolve(model)
        )
      else
        deferred.resolve(data)
      return deferred.promise

]