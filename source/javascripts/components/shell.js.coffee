Crafty.sprite(undefined, "images/shell.png",
  shellSprite: [0, 0])

Crafty.c "PlayerShot",
  init: ->
    @.requires("2D, DOM, shellSprite, Collision")
