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

    @player.bind("AlienHit", @alienHit)


  createAliens: ->
    # Create aliens
    @alienMoveCounter = 0

    @aliens = []
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

        @aliens.push(alien)

    @leftmostAlien = @aliens[0]
    @rightmostAlien = @aliens[@aliens.length - 1]

  update: (updateData) =>
    @handleAlienMovement(updateData.dt)

  handleAlienMovement: (dt) ->
    if @alienMoveCounter < AlienConstants.MOVEMENT_INTERVAL
      @alienMoveCounter += dt
    else
      @alienMoveCounter = 0
      if @aliensMovingOutsideScreen()
        alien.descend() for alien in @aliens when alien != null
      else
        alien.advance() for alien in @aliens when alien != null

  aliensMovingOutsideScreen: ->
    (@leftmostAlien.direction == 'w' and (@leftmostAlien.x - AlienConstants.HORIZONTAL_SPEED < 0)) or
    (@rightmostAlien.direction == 'e' and
      (@rightmostAlien.x + AlienConstants.WIDTH + AlienConstants.HORIZONTAL_SPEED > Crafty.viewport.width))

  alienHit: (alien) =>
    @score.addScore(alien.pointsWorth())
    @destroyAlien(alien)
    #@checkVictory()

  destroyAlien: (alien) ->
    @updateRightmostAlien(alien)
    @updateLeftmostAlien(alien)
    @aliens[alien.index] = null
    alien.destroy()

  updateRightmostAlien: (alienDestroyed) ->
    return if alienDestroyed != @rightmostAlien

    potentialRightmostAliens = @aliens[0...(alienDestroyed.index)]
    potentialRightmostAliens = (alien for alien in potentialRightmostAliens when alien != null)

    @rightmostAlien = potentialRightmostAliens[potentialRightmostAliens.length - 1]
    @rightmostAlien.rotation(180)

  updateLeftmostAlien: (alienDestroyed) ->
    return if alienDestroyed != @leftmostAlien

    potentialLeftmostAliens = @aliens[(alienDestroyed.index + 1)..]
    potentialLeftmostAliens = (alien for alien in potentialLeftmostAliens when alien != null)

    @leftmostAlien = potentialLeftmostAliens[0]
