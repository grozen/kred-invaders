Crafty.sprite(imageFileAssetHashNameMap['shell'], shellSprite: [0, 0, 7, 10])

Crafty.c "PlayerShot",
  init: ->
    @.requires("2D, DOM, shellSprite, Collision")
    @stop()

    @.checkHits('Alien, Ship, Shield, AlienShot, Spaceship')

  fireFrom: (x, y) ->
    @.attr(x: x, y: y, visible: true)
    @.bind("EnterFrame", @advance)
    @active = true
    return @

  advance: ->
    @.move('n', PlayerConstants.SHOT_SPEED)
    @stop() if @outsidePlayfield()
    return @

  stop: ->
    @.attr(x: PlayerConstants.SHOT_IDLE_X, y: PlayerConstants.SHOT_IDLE_Y, visible: false)
    @.unbind("EnterFrame", @advance)
    @active = false
    Crafty.trigger("ShotStopped", @)
    return @

  isActive: ->
    @active

  outsidePlayfield: ->
    @.y < 0
