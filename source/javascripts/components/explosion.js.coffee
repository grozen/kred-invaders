class @ExplosionConstants
  @IDLE_X = -200
  @IDLE_Y = -300

Crafty.c "Explosion",
  init: ->
    @.requires("2D, DOM, SpriteAnimation")
    @text = Crafty.e("2D, DOM, Text")

  explosion: (spriteName, repeatCount, duration, frameCount) ->
    @.addComponent(spriteName)

    @.reel("Explode", duration, 0, 0, frameCount)
    @repeatCount = repeatCount

    @.bind("AnimationEnd", @explosionEnded)

    @text.unselectable().css('text-align': 'center')

    @hide()

    return @

  explosionText: (@message, textColor, @textSize) ->
    @text.textColor(textColor)
    @text.textFont(size: "#{@textSize}px", family: 'Silkscreen Expanded')

    return @

  explodeAt: (x, y) ->
    @.attr(x: x, y: y, visible: true)
    @.animate("Explode", @repeatCount)

    if (@message)
      @text.attr(
        visible: true,
        x: @.x,
        w: @.w,
        y: Math.floor(@.y + @.h / 2 - @textSize / 2))
      @text.text(@message)

    return @

  explosionEnded: ->
    @.trigger("ExplosionEnded", @)
    @hide()

  hide: ->
    @.attr(x: ExplosionConstants.IDLE_X, y: ExplosionConstants.IDLE_Y, visible: false)
    @text.attr(visible: false)

    return @
