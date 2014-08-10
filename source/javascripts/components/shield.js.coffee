class @ShieldConstants
  @WIDTH = @HEIGHT = 12

Crafty.sprite(ShieldConstants.WIDTH, imageFileAssetHashNameMap['shield'],
  shieldSprite: [0, 0])

Crafty.c "Shield",
  init: ->
    @.requires("2D, DOM, shieldSprite, SpriteAnimation")

    @.reel("Degrade", 1, 0, 0, 5)
    @.reel("Degrade")
    @degradation = 0

  shield: (x, y) ->
    @.attr(x: x, y: y)
    return @

  degrade: ->
    @degradation += 1

    if (@degradation >= @.getReel().frames.length)
      @.destroy()
    else
      @.reelPosition(@degradation)
