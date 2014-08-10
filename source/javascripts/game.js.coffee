class @Game
  constructor: ->
    @initialize()

  initialize: ->
    # Create the player
    @player = Crafty.e("Player")

    @player.setPosition(
      Crafty.viewport.width / 2 - PlayerConstants.WIDTH / 2,
      Crafty.viewport.height - PlayerConstants.HEIGHT)

    @score = Crafty.e("Score")

    @createAliens()
    @createShields()

    @player.bind("AlienHit", @alienHit)
    @player.bind("ShieldHit", @shieldHit)

  createAliens: ->
    # Create aliens
    @alienMoveCounter = 0

    @aliens = new DLL.DoublyLinkedList()
    leftStart = Crafty.viewport.width / 2 - AlienConstants.WIDTH * 5.5
    bottomStart = 400
    alienIndex = 0
    for column in [0...11]
      for row in [0...5]
        alien = Crafty.e("Alien").alien(
          1,
          leftStart + AlienConstants.WIDTH * column,
          bottomStart - AlienConstants.HEIGHT * row,
          alienIndex++)

        node = @aliens.append(alien)
        alien.setContainingNode(node)

  createShields: ->
    Crafty.e("Shield").shield(400, 450)

  leftmostAlien: ->
    @aliens.head().data

  rightmostAlien: ->
    @aliens.tail().data

  update: (updateData) =>
    @handleAlienMovement(updateData.dt)

  handleAlienMovement: (dt) ->
    if @alienMoveCounter < AlienConstants.MOVEMENT_INTERVAL
      @alienMoveCounter += dt
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
