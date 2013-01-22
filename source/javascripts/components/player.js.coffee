PLAYER_WIDTH = 64

Crafty.sprite(PLAYER_WIDTH, "images/player_base.png",
  playerBase: [0, 0])

Crafty.c "Player",
  init: ->
    @.requires("2D, DOM, Multiway, PlayerBase, Collision")

    # Position the player
    x = Crafty.viewport.width / 2 - PLAYER_WIDTH / 2
    y = Crafty.viewport.height - PLAYER_WIDTH

