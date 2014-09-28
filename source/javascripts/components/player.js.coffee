Crafty.c 'Player',
  init: ->
    @.requires('Keyboard')
    @body = Crafty.e('PlayerBody')
    @cannon = Crafty.e('PlayerCannon')
    @shot = Crafty.e('PlayerShot')
    @isShooting = false

    @.bind("KeyDown", @keyDown)
    @.bind("KeyUp", @keyUp)

    @shotHit = (hitInfo) =>
      target = hitInfo[0].obj
      if target.has('Alien')
        @.trigger('AlienHit', target)
      if target.has('Shield')
        @.trigger('ShieldHit', target)
      if target.has('AlienShot')
        @.trigger('AlienShotHit', target)
      if target.has('Spaceship')
        @.trigger('SpaceshipHit', [@shot, target])

      @shot.stop()

    @shot.bind("HitOn", @shotHit)

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
      unless @isShooting
        @isShooting = true
        @shoot()
        @.bind("ShotStopped", @shoot)

  keyUp: ->
    if not @.isDown(Crafty.keys.SPACE)
      if @isShooting
        @isShooting = false
        @.unbind("ShotStopped", @shoot)
