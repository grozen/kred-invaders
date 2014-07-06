class @PlayerConstants
  @WIDTH = @HEIGHT = 64
  @SPEED = 3
  @MOVEMENT_ANIMATION_DURATION = 250
  @FIRE_ANIMATION_DURATION = 300
  @RELOAD_ANIMATION_DURATION = 500
  @SHOT_SPEED = 8

# Behavior common to most components making out the player
Crafty.c 'PlayerCommon',
  init: ->
    @tmp = null

    @.requires("2D, DOM, Multiway")
    @.multiway(PlayerConstants.SPEED,
      LEFT_ARROW: 180
      RIGHT_ARROW: 0)

    @.bind("NewDirection", (info) -> @direction = info)

    @.bind("Moved", (info) ->
      if @movingOutsidePlayfield(info.x, @direction)
        # Reset position back to the previous position
        @.attr
          x: info.x
          y: info.y)

  movingOutsidePlayfield: (x, direction) ->
    @tmp = x + direction.x
    (@tmp < 0) or (@tmp + @._w > Crafty.viewport.width)
