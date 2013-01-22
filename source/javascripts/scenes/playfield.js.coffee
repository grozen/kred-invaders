Crafty.scene 'playfield', ->
  Crafty.background('rgb(32, 55, 67)')
  player = Crafty.e("Player")
  player.attr
    x: Crafty.viewport.width / 2 - player.w / 2
    y: Crafty.viewport.height - player.h
