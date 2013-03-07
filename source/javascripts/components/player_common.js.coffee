class @PlayerConstants
  @WIDTH = @HEIGHT = 64
  @SPEED = 3
  @MOVEMENT_DURATION = 8

# Behavior common to all components making out the player
Crafty.c 'PlayerCommon',
  init: ->
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
    newX = x + direction.x
    (newX < 0) or (newX + @.w > Crafty.viewport.width)
