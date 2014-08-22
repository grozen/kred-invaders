Crafty.sprite(imageFileAssetHashNameMap['alien_shot'], alienShot: [0, 0])

Crafty.c "AlienShot",
  init: ->
    @.requires("2D, DOM, alienShot, Collision")
    @stop()

    @.checkHits('Player, Shield')

  fireFrom: (x, y) ->
    @.attr(x: x, y: y, visible: true)
    @.bind("EnterFrame", @advance)
    return @

  advance: ->
    @.move('s', AlienConstants.SHOT_SPEED)
    @stop() if @outsidePlayfield()
    return @

  stop: ->
    @.attr(x: -100, y: -100, visible: false)
    @.unbind("EnterFrame", @advance)
    Crafty.trigger("ShotStopped", @)
    return @

  outsidePlayfield: ->
    @.y > Crafty.viewport.height

  setContainingList: (shotList) ->
    @containingList = shotList
