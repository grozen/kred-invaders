class @Game
  constructor: ->
    @initialize()

  initialize: ->
    @player = Crafty.e("Player")

    @player.setPosition(
      Crafty.viewport.width / 2 - PlayerConstants.WIDTH / 2,
      Crafty.viewport.height - PlayerConstants.HEIGHT)

    @score = Crafty.e("Score")

    @createAliens()
    @createAlienShots()
    @createShields()

    @player.bind("AlienHit", @alienHit)
    @player.bind("ShieldHit", @shieldHit)

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

  createAlienShots: ->
    @alienShots = new DLL.DoublyLinkedList()
    for _ in [0..AlienConstants.MAX_SHOTS]
      alienShot = Crafty.e("AlienShot")
      @alienShots.append(alienShot)
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
      @handleAlienShots

  # Returns true if the aliens moved
  handleAlienMovement: (dt) ->
    if @alienMoveCounter < AlienConstants.MOVEMENT_INTERVAL
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

    while (alienNode)
      # TODO: shoot the player here
      alienNode = alienNode.next

  aliensMovingOutsideScreen: ->
    (@leftmostAlien().direction == 'w' and (@leftmostAlien().x - AlienConstants.HORIZONTAL_SPEED < 0)) or
    (@rightmostAlien().direction == 'e' and
      (@rightmostAlien().x + AlienConstants.WIDTH + AlienConstants.HORIZONTAL_SPEED > Crafty.viewport.width))

  alienHit: (alien) =>
    @score.addScore(alien.pointsWorth())
    alien.destroy()
    #@checkVictory()

  shieldHit: (shield) =>
    shield.degrade()
