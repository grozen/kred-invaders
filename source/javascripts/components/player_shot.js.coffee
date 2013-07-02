Crafty.sprite("images/shell.png", shellSprite: [0, 0, 7, 10])

Crafty.c "PlayerShot",
  init: ->
    @.requires("2D, DOM, shellSprite, Collision")
    @stop()

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
    @.attr(x: -100, y: -100, visible: false)
    @.unbind("EnterFrame")
    @active = false
    Crafty.trigger("ShotStopped", @)
    return @

  isActive: ->
    @active

  outsidePlayfield: ->
    @.y < 0
