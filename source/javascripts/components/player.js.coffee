PLAYER_WIDTH = 64

Crafty.sprite(PLAYER_WIDTH, "images/player_base.png",
  playerBase: [0, 0])

Crafty.c "Player",
  init: ->
    @.requires("2D, DOM, Multiway, playerBase, Collision")
