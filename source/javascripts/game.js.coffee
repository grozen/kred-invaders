class @Game
  constructor: ->
    @initialize()

  initialize: ->
    @player = Crafty.e("Player")

    @player.setPosition(
      Crafty.viewport.width / 2 - PlayerConstants.WIDTH / 2,
      Crafty.viewport.height - PlayerConstants.HEIGHT)

    @score = Crafty.e("Score")
    @lives = Crafty.e("Lives")

    @score.bind("LifeIncrement", => @lives.lifeUp())

    Crafty.e("playerLife").attr(x: 400, y: 400, visible: true)

    @createAliens()
    @createAlienShots()
    @createShields()
    @createSpaceship()

    @player.bind("AlienHit", @alienHit)
    @player.bind("SpaceshipHit", @spaceshipHit)
    @player.bind("ShieldHit", @shieldHit)
    @player.bind("AlienShotHit", @alienShotHit)
    @player.bind("Respawning", @playerRespawning)

  createSpaceship: ->
    @shipSpawnCounter = 0
    @spaceship = Crafty.e("Spaceship")
    @spaceship.destroy()

  createAliens: ->
    @alienMoveCounter = 0

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

        node = @aliens.append(alien)
        alien.setContainingNode(node)

    @alienCount = @aliens.size()

  createAlienShots: ->
    @alienShots = new DLL.DoublyLinkedList()
    for _ in [0..AlienShotConstants.MAX_SHOTS - 1]
      alienShot = Crafty.e("AlienShot")
      alienShot.bind("ShieldHit", @shieldHit)
      alienShot.bind("PlayerHit", @playerHit)
      alienShotNode = @alienShots.append(alienShot)

      alienShot.setContainingNode(alienShotNode)
      alienShot.setContainingList(@alienShots)

  createShields: ->
    spacing = 80
    middle = Crafty.viewport.width / 2
    @createShieldFormation(middle - spacing * 3, 500)
    @createShieldFormation(middle - spacing, 500)
    @createShieldFormation(middle + spacing, 500)
    @createShieldFormation(middle + spacing * 3, 500)

  createShieldFormation: (x, y) ->
    size = ShieldConstants.WIDTH
    Crafty.e("Shield").shield(x - 0.5 * size, y - 2 * size)
    Crafty.e("Shield").shield(x - 1.5 * size, y - 2 * size)
    Crafty.e("Shield").shield(x + 0.5 * size, y - 2 * size)
    Crafty.e("Shield").shield(x - 1.5 * size, y - size)
    Crafty.e("Shield").shield(x + 0.5 * size, y - size)
    Crafty.e("Shield").shield(x - 2.5 * size, y - size)
    Crafty.e("Shield").shield(x + 1.5 * size, y - size)
    Crafty.e("Shield").shield(x - 2.5 * size, y)
    Crafty.e("Shield").shield(x + 1.5 * size, y)

  leftmostAlien: ->
    @aliens.head().data

  rightmostAlien: ->
    @aliens.tail().data

  update: (updateData) =>
    if (@handleAlienMovement(updateData.dt))
      @handleAlienShots()

    @handleShipSpawning(updateData.dt)

  handleShipSpawning: (dt) ->
    if @shipSpawnCounter < ShipConstants.SPAWN_CHANCE_INTERVAL
      @shipSpawnCounter += dt unless @spaceship.isFlying()
    else
      @shipSpawnCounter = 0
      if Random.getInRange(0, 100) < ShipConstants.SPAWN_CHANCE
        @spaceship.flyTowards(if Math.round(Math.random()) then 'w' else 'e')

  # Returns true if the aliens moved
  handleAlienMovement: (dt) ->
    if @alienMoveCounter < AlienConstants.MOVEMENT_INTERVAL / Math.pow(80, 1 - (@aliens.size() / @alienCount))
      @alienMoveCounter += dt
      false
    else
      @alienMoveCounter = 0
      alienNode = @aliens.head()
      if @aliensMovingOutsideScreen()
        while (alienNode)
          alienNode.data.descend()
          alienNode = alienNode.next
      else
        while (alienNode)
          alienNode.data.advance()
          alienNode = alienNode.next

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
    @score.addScore(alien.pointsWorth())
    alien.destroy()
    #TODO: @checkVictory() ?

  spaceshipHit: (hitDataArray) =>
    playerShot = hitDataArray[0]
    spaceship = hitDataArray[1]
    @score.addScore(spaceship.pointsWorth(playerShot))
    spaceship.destroy()

  shieldHit: (shield) =>
    shield.degrade()

  alienShotHit: (alienShot) =>
    @score.addScore(alienShot.pointsWorth())
    alienShot.stop()

  playerHit: (player) =>
    @lives.lifeDown()
    @player.die()

  playerRespawning: (player) =>
    console.log("OMG I am so dead!")
    #TODO: Check if player is out of life, end game if so
