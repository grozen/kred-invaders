Crafty.scene 'playfield', ->
  Crafty.background('rgb(32, 55, 67)')

  game = new Game()
  Crafty.bind("EnterFrame", game.update)
