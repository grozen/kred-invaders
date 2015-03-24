Crafty.sprite(AlienConstants.WIDTH, imageFileAssetHashNameMap['alien_explosion'], alienExplosion: [0, 0])

class @Game
  constructor: ->
    @initialize()

  initialize: ->
    Crafty.audio.setChannels(10)

    @inputSink = Crafty.e("Keyboard")
    @player = Crafty.e("Player")
    @banner = Crafty.e("Banner")
    @score = Crafty.e("Score")
    @lives = Crafty.e("Lives")
    @spaceship = Crafty.e("Spaceship")

    @createAliens()
    @createAlienShots()
    @createAlienExplosions()
    @createShields()

    @score.bind("LifeIncrement", => @lives.lifeUp())

    @player.bind("AlienHit", @alienHit)
    @player.bind("SpaceshipHit", @spaceshipHit)
    @player.bind("ShieldHit", @shieldHit)
    @player.bind("AlienShotHit", @alienShotHit)
    @player.bind("Respawning", @playerRespawning)
    @player.bind("HitByAlien", @playerAlienCollision)

    @.resetBoard()

  resetBoard: ->
    @banner.hide()

    @lives.reset()

    @player_won = false

    @player.setPosition(
      Crafty.viewport.width / 2 - PlayerConstants.WIDTH / 2,
      Crafty.viewport.height - PlayerConstants.HEIGHT)
    @player.show()
    @player.enableControl()

    @score.reset()

    @.resetAliens()
    @.resetAlienShots()
    @.resetSpaceship()
    @.resetShields()

  nextRound: ->
    @inputSink.unbind("KeyUp")
    @banner.hide()

    @player_won = false

    @player.enableShooting()

    @.resetAliens()
    @.resetAlienShots()


  resetSpaceship: ->
    @shipSpawnCounter = 0
    @spaceship.hide()

  createAliens: ->
    @alienMoveSoundIndex = 0
    @alienPool = []

    @aliens = new DLL.DoublyLinkedList()
    leftStart = Crafty.viewport.width / 2 - AlienConstants.WIDTH * 5.5
    topStart = 100
    alienIndex = 0
    for column in [0...11]
      for row in [0...5]
        alien = Crafty.e("Alien").alien(
          3 - Math.floor((row + 1) / 2),
          leftStart + AlienConstants.WIDTH * column,
          topStart + AlienConstants.HEIGHT * row,
          alienIndex++)

        @alienPool.push(alien)

    @alienCount = @alienPool.length

  resetAliens: ->
    @alienMoveCounter = 0
    @aliens = new DLL.DoublyLinkedList()

    for alien in @alienPool
      node = @aliens.append(alien)
      alien.respawn().setContainingNode(node)

    @.updateAlienMoveInterval()

  updateAlienMoveInterval: ->
    @alienMoveInterval = AlienConstants.MOVEMENT_INTERVAL / Math.pow(80, 1 - (@aliens.size() / @alienCount))

  createAlienShots: ->
    @alienShotPool = []

    @alienShots = new DLL.DoublyLinkedList()
    for _ in [0..AlienShotConstants.MAX_SHOTS - 1]
      alienShot = Crafty.e("AlienShot")
      alienShot.bind("ShieldHit", @shieldHit)
      alienShot.bind("PlayerHit", @playerHit)
      alienShotNode = @alienShots.append(alienShot)

      alienShot.setContainingNode(alienShotNode)
      alienShot.setContainingList(@alienShots)

      @alienShotPool.push(alienShot)

  createAlienExplosions: ->
    explosions = @alienExplosions = new DLL.DoublyLinkedList()
    for _ in [0..6]
      alienExplosion = Crafty.e('Explosion').explosion('alienExplosion', 1, 500, 2)
      alienExplosion.bind("ExplosionEnded", -> explosions.append(@))

      @alienExplosions.append(alienExplosion)

  resetAlienShots: ->
    for alienShot in @alienShotPool
      alienShot.stop()

  createShields: ->
    @shieldPool = []
    spacing = 80
    middle = Crafty.viewport.width / 2
    @createShieldFormation(middle - spacing * 3, 500)
    @createShieldFormation(middle - spacing, 500)
    @createShieldFormation(middle + spacing, 500)
    @createShieldFormation(middle + spacing * 3, 500)

  createShieldFormation: (x, y) ->
    size = ShieldConstants.WIDTH

    coordinates =
      [[x - 0.5 * size, y - 2 * size]
       [x - 1.5 * size, y - 2 * size]
       [x + 0.5 * size, y - 2 * size]
       [x - 1.5 * size, y - size]
       [x + 0.5 * size, y - size]
       [x - 2.5 * size, y - size]
       [x + 1.5 * size, y - size]
       [x - 2.5 * size, y]
       [x + 1.5 * size, y]]

    for coordinate in coordinates
      shieldBlock = Crafty.e("Shield")
      @shieldPool.push(shieldBlock.shield.apply(shieldBlock, coordinate))

  resetShields: ->
    (shield.respawn() for shield in @shieldPool)

  leftmostAlien: ->
    @aliens.head().data

  rightmostAlien: ->
    @aliens.tail().data

  update: (updateData) =>
    if (@handleAlienMovement(updateData.dt))
      @handleAlienShots() unless @player.isDead()

    @handleShipSpawning(updateData.dt) unless @player_won

  handleShipSpawning: (dt) ->
    if @shipSpawnCounter < ShipConstants.SPAWN_CHANCE_INTERVAL
      @shipSpawnCounter += dt unless @spaceship.isFlying()
    else
      @shipSpawnCounter = 0
      if Random.getInRange(0, 100) < ShipConstants.SPAWN_CHANCE
        @spaceship.flyTowards(if Math.round(Math.random()) then 'w' else 'e')

  # Returns true if the aliens moved
  handleAlienMovement: (dt) ->
    if @alienMoveCounter < @alienMoveInterval
      @alienMoveCounter += dt
      false
    else
      @alienMoveCounter = 0
      alienNode = @aliens.head()
      return false unless alienNode

      if @aliensMovingOutsideScreen()
        while (alienNode)
          alien = alienNode.data
          alien.descend()

          # An alien that reaches the bottom of the screen is game over, man
          if (alien.y + AlienConstants.HEIGHT > Crafty.viewport.height)
            alien.dieSilently()
            @lives.deplete()
            @player.die()

          alienNode = alienNode.next
      else
        while (alienNode)
          alienNode.data.advance()
          alienNode = alienNode.next

      @alienMoveSoundIndex = (@alienMoveSoundIndex + 1) % 2
      @alienMoveSoundId = Crafty.audio.play("alien_move#{@alienMoveSoundIndex}")

      true

  handleAlienShots: ->
    alienNode = @aliens.head()

    while (alienNode && @alienShots.size() > 0)
      if (Random.getInRange(0, 100) < AlienShotConstants.BASE_SHOT_CHANCE)
        shotNode = @alienShots.head()
        continue unless shotNode

        shotNode.data.fireBy(alienNode.data)

      alienNode = alienNode.next

  aliensMovingOutsideScreen: ->
    (@leftmostAlien().direction == 'w' and (@leftmostAlien().x - AlienConstants.HORIZONTAL_SPEED < 0)) or
    (@rightmostAlien().direction == 'e' and
      (@rightmostAlien().x + AlienConstants.WIDTH + AlienConstants.HORIZONTAL_SPEED > Crafty.viewport.width))

  alienHit: (alien) =>
    pointsGained = alien.pointsWorth()
    @score.addScore(pointsGained)

    alienExplosionNode = @alienExplosions.head()
    alienExplosionNode.remove()
    alienExplosionNode.data.explosionText("#{pointsGained}", '#FFFFFF', 10).explodeAt(alien.x, alien.y)

    alien.die()
    @.updateAlienMoveInterval()

    @.victory() if @aliens.size() == 0

  spaceshipHit: (hitDataArray) =>
    playerShot = hitDataArray[0]
    spaceship = hitDataArray[1]
    pointsGained = spaceship.pointsWorth(playerShot)

    @score.addScore(pointsGained)
    spaceship.destroy(pointsGained)

  shieldHit: (shield) =>
    shield.degrade()

  alienShotHit: (alienShot) =>
    @score.addScore(alienShot.pointsWorth())
    alienShot.die()

  playerHit: (player) =>
    @lives.lifeDown() if @player.die()

  playerAlienCollision: (alien) =>
    @lives.deplete() if @player.die()

  playerRespawning: (player) =>
    if (@lives.lives == 0)
      @.gameOver()

  gameOver: ->
    @player.hide()
    @player.disableControl()

    @banner.show("Game Over", "Final score - #{@score.getScore()}<br>Press any key to try again", 500, 200, 600, 400)

    @inputSink.one("KeyUp", =>
      @.resetBoard())

  victory: ->
    @banner.show("Victory", "Well done, but more aliens are inbound!<br>Press space to persevere", 500, 200, 600, 300)
    @player.disableShooting()
    @player_won = true

    @inputSink.bind("KeyUp", (e) =>
      @.nextRound() if e.key == Crafty.keys.SPACE)
