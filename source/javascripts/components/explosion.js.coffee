class @ExplosionConstants
  @IDLE_X = -200
  @IDLE_Y = -300

Crafty.c "Explosion",
  init: ->
    @.requires("2D, DOM, SpriteAnimation")

  explosion: (spriteName, repeatCount, duration, frameCount) ->
    @.addComponent(spriteName)

    @.reel("Explode", duration, 0, 0, frameCount)
    @repeatCount = repeatCount

    @.bind("AnimationEnd", @explosionEnded)

    @hide()

    return @

  explodeAt: (x, y) ->
    @.attr(x: x, y: y, visible: true)
    @.animate("Explode", @repeatCount)

    return @

  explosionEnded: ->
    @.trigger("ExplosionEnded", @)
    @hide()

  hide: ->
    @.attr(x: ExplosionConstants.IDLE_X, y: ExplosionConstants.IDLE_Y, visible: false)

    return @
