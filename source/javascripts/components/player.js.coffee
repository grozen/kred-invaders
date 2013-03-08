Crafty.c 'Player',
  init: ->
    @.requires('Keyboard')
    @body = Crafty.e('PlayerBody')
    @cannon = Crafty.e('PlayerCannon')

    @bind("KeyDown", @keyDown)

  setPosition: (x, y) ->
    @body.attr(x: x, y: y)
    @cannon.attr(x: x, y: y)
    return @

  keyDown: ->
    @cannon.fire() if @.isDown(Crafty.keys.SPACE)
