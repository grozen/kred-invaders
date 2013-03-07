Crafty.scene 'playfield', ->
  Crafty.background('rgb(32, 55, 67)')
  player = Crafty.e("Player")
  player.setPosition(
    Crafty.viewport.width / 2 - PlayerConstants.WIDTH / 2,
    Crafty.viewport.height - PlayerConstants.HEIGHT)
