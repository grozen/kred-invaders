Crafty.c 'Player',
  init: ->
    @.requires('Keyboard')
    @body = Crafty.e('PlayerBody')
    @cannon = Crafty.e('PlayerCannon')
    @shot = Crafty.e('PlayerShot')

    @.bind("KeyDown", @keyDown)
    @.bind("KeyUp", @keyUp)

  setPosition: (x, y) ->
    @body.attr(x: x, y: y)
    @cannon.attr(x: x, y: y)
    return @

  x: ->
    @body.x

  y: ->
    @body.y

  shoot: ->
    unless @shot.isActive()
      @cannon.fire()
      @shot.fireFrom(@x() + 29, @y() + 16)
    return @

  keyDown: ->
    if @.isDown(Crafty.keys.SPACE)
      @.bind("EnterFrame", @shoot)

  keyUp: ->
    if not @.isDown(Crafty.keys.SPACE)
      @.unbind("EnterFrame", @shoot)
