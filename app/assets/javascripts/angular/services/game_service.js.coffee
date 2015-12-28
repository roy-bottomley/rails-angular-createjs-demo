@TfCardsApp.service 'gameService', [

  # a wrapper for a createJS stage which can be injected
  # so that any model can have access to the stage
  class gameService

    # called by the creativeCanvas directive
    # once the DOM is loaded, the canvas element created
    # and the createiveJS stage is initialised
    stageReady: (@stage) ->
      # set the stage ready for tweening
      tickerHandler = (event)=>
        @stage.update(event);

      createjs.Ticker.setFPS(60);
      createjs.Ticker.addEventListener("tick", tickerHandler);

# set the given object to the top of the zOrder
    setChildOnTop: (child) ->
      # method to sort objects
      sortByZ = (a,b) -> return a.zIndex - b.zIndex;

      # sort the object in the stage  
      @stage.sortChildren(sortByZ);
      # set the zOrder of the desired object to be the highest
      last =    @stage.children[@stage.children.length - 1]
      lastz = last.zIndex
      child.zIndex =  @stage.children[@stage.children.length - 1].zIndex + 1

      # sort the stages objects so that the desired object is now on top
      @stage.sortChildren(sortByZ)
      
    # pass through to the services @stage  
    addChild: (object) =>
      @stage.addChild(object);

    update: () =>
      @stage.update();




]
