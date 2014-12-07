class @ShieldConstants
  @WIDTH = @HEIGHT = 12
  @IDLE_X = -50
  @IDLE_Y = 90

Crafty.sprite(ShieldConstants.WIDTH, imageFileAssetHashNameMap['shield'],
  shieldSprite: [0, 0])

Crafty.c "Shield",
  init: ->
    @.requires("2D, DOM, shieldSprite, SpriteAnimation")

    @.reel("Degrade", 1, 0, 0, 5)
    @.reel("Degrade")

  shield: (x, y) ->
    @spawnX = x
    @spawnY = y
    return @

  degrade: ->
    @degradation += 1

    if (@degradation >= @.getReel().frames.length)
      @.attr(x: ShieldConstants.IDLE_X, y: ShieldConstants.IDLE_Y, visible: false)
    else
      @.reelPosition(@degradation)

    return @

  respawn: ->
    @degradation = 0
    @.attr(x: @spawnX, y: @spawnY, visible: true)
    return @
