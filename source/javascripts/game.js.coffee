class @Game
  constructor: ->
    # Create the player
    @player = Crafty.e("Player")
    @player.setPosition(
      Crafty.viewport.width / 2 - PlayerConstants.WIDTH / 2,
      Crafty.viewport.height - PlayerConstants.HEIGHT)

    # Create aliens
    @alienMoveInterval = 50
    @alienMoveCounter = @alienMoveInterval
    Crafty.e("Alien").alien(1, 400, 50)

  update: ->
    @handleAlienMovement()

  handleAlienMovement: ->
