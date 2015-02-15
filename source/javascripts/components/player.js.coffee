Crafty.sprite(PlayerConstants.WIDTH, imageFileAssetHashNameMap['player_explosion'], playerExplosion: [0, 0])

Crafty.c 'Player',
  init: ->
    @.requires('Keyboard')
    @body = Crafty.e('PlayerBody')
    @cannon = Crafty.e('PlayerCannon')
    @shot = Crafty.e('PlayerShot')
    @explosion = Crafty.e('Explosion').explosion('playerExplosion', 3, 1000, 2)
    @isShooting = false
    @shootingDisabled = false

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

    @playerHit = (hitInfo) =>
      target = hitInfo[0].obj
      if target.has('Alien')
        @.trigger('HitByAlien', target)

    @shot.bind("HitOn", @shotHit)
    @body.bind("HitOn", @playerHit)

    @explosion.bind("ExplosionEnded", => @.respawn())

  setPosition: (x, y) ->
    @body.attr(x: x, y: y)
    @cannon.attr(x: x, y: y)
    return @

  x: ->
    @body.x

  y: ->
    @body.y

  show: ->
    @body.attr(visible: true)
    @cannon.attr(visible: true)

  hide: ->
    @body.attr(visible: false)
    @cannon.attr(visible: false)

  shoot: ->
    unless @shot.isActive()
      @cannon.fire()
      @shot.fireFrom(@x() + 29, @y() + 16)
      Crafty.audio.play('player_shoot')
    return @

  die: ->
    if @.isDead() == false
      @explosion.explodeAt(@body.x, @body.y)
      @.disableControl()
      @.stopShooting()
      @.hide()
      Crafty.audio.play('player_die')
      return true

    return false

  isDead: ->
    !@body._visible

  respawn: ->
    @.enableControl()
    @.show()
    @.trigger("Respawning", @)

  keyDown: ->
    if @.isDown(Crafty.keys.SPACE) && @shootingDisabled == false
      @.startShooting()

  keyUp: ->
    if not @.isDown(Crafty.keys.SPACE)
      @.stopShooting()

  startShooting: ->
    unless @isShooting
      @isShooting = true
      @shoot()
      @.bind("ShotStopped", @shoot)

  stopShooting: ->
    if @isShooting
      @isShooting = false
      @.unbind("ShotStopped", @shoot)

  enableControl: ->
    @body.enableControl()
    @cannon.enableControl()
    @.enableShooting()
    @.bind("KeyDown", @keyDown)
    @.bind("KeyUp", @keyUp)

  disableControl: ->
    @body.disableControl()
    @cannon.disableControl()
    @.unbind("KeyDown", @keyDown)
    @.unbind("KeyUp", @keyUp)

  disableShooting: ->
    @shootingDisabled = true

  enableShooting: ->
    @shootingDisabled = false
