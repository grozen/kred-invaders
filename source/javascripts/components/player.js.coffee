Crafty.sprite(PlayerConstants.WIDTH, imageFileAssetHashNameMap['player_explosion'], playerExplosion: [0, 0])

Crafty.c 'Player',
  init: ->
    @.requires('Keyboard')
    @body = Crafty.e('PlayerBody')
    @cannon = Crafty.e('PlayerCannon')
    @shot = Crafty.e('PlayerShot')
    @explosion = Crafty.e('Explosion').explosion('playerExplosion', 3, 1000, 2)
    @isShooting = false

    @.enableControl()

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

    @explosion.bind("ExplosionEnded", => @.trigger("Died", @))

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

  die: ->
    @explosion.explodeAt(@body.x, @body.y)

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

  enableControl: ->
    @body.enableControl()
    @cannon.enableControl()
    @.bind("KeyDown", @keyDown)
    @.bind("KeyUp", @keyUp)

  disableControl: ->
    @body.disableControl()
    @cannon.disableControl()
    @.unbind("KeyDown", @keyDown)
    @.unbind("KeyUp", @keyUp)
