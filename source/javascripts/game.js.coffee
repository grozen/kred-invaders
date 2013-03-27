class @Game
  constructor: ->
    # Create the player
    @player = Crafty.e("Player")
    @player.setPosition(
      Crafty.viewport.width / 2 - PlayerConstants.WIDTH / 2,
      Crafty.viewport.height - PlayerConstants.HEIGHT)

    # Create aliens
    Crafty.e("Alien").alien(1, 400, 50)

  update: ->
    # update some game things here
