PLAYER_WIDTH = 64
PLAYER_SPEED = 4
PLAYER_MOVEMENT_FPS = 10

Crafty.sprite(PLAYER_WIDTH, "images/player_base.png",
  playerBase: [0, 0])

Crafty.c "Player",
  init: ->
    @.requires("2D, DOM, Multiway, playerBase, SpriteAnimation, Collision")
    @.multiway(PLAYER_SPEED,
      LEFT_ARROW: 180
      RIGHT_ARROW: 0)

    @.animate("MoveRight", 0, 0, 7)
    @.animate("MoveLeft", 7, 0, 0)

    @.bind("Moved", @moved)
    @.bind("NewDirection", @changedDirection)

  moved: (info) ->
    if @movingOutsidePlayfield(info.x, @direction)
      # Reset position back to the previous position
      @.attr
        x: info.x
        y: info.y

  movingOutsidePlayfield: (x, direction) ->
    newX = x + direction.x
    (newX < 0) or (newX + @.w > Crafty.viewport.width)

  changedDirection: (info) ->
    @direction = info
    switch @direction.x
      when 0 then @.stop()
      when PLAYER_SPEED then @.animate("MoveRight", PLAYER_MOVEMENT_FPS, -1)
      when -PLAYER_SPEED then @.animate("MoveLeft", PLAYER_MOVEMENT_FPS, -1)
