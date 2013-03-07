Crafty.c 'Player',
  init: ->
    @body = Crafty.e('PlayerBody')
    @cannon = Crafty.e('PlayerCannon')

  setPosition: (x, y) ->
    @body.attr(x: x, y: y)
    @cannon.attr(x: x, y: y)
    return @
