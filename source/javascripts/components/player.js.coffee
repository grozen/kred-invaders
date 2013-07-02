self = null

Crafty.c 'Player',
  init: ->
    @.requires('Keyboard')
    @body = Crafty.e('PlayerBody')
    @cannon = Crafty.e('PlayerCannon')
    @shot = Crafty.e('PlayerShot')
    @isShooting = false

    self = @

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
    # I use "self" here so that I can bind to the shot and still maintain
    # context.
    unless self.shot.isActive()
      self.cannon.fire()
      self.shot.fireFrom(self.x() + 29, self.y() + 16)
    return self

  keyDown: ->
    if @.isDown(Crafty.keys.SPACE)
      unless @isShooting
        @isShooting = true
        @shoot()
        @shot.bind("ShotStopped", @shoot)

  keyUp: ->
    if not @.isDown(Crafty.keys.SPACE)
      if @isShooting
        @isShooting = false
        @shot.unbind("ShotStopped", @shoot)
