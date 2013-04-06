class @Game
  constructor: ->
    @initialize()

  initialize: ->
    # Create the player
    @player = Crafty.e("Player")
    @player.setPosition(
      Crafty.viewport.width / 2 - PlayerConstants.WIDTH / 2,
      Crafty.viewport.height - PlayerConstants.HEIGHT)

    # Create aliens
    @alienMoveInterval = 50
    @alienMoveCounter = @alienMoveInterval
    @aliens = [Crafty.e("Alien").alien(1, 400, 50)]
    @leftmostAlien = @aliens[0]
    @rightmostAlien = @aliens[@aliens.length - 1]

  update: =>
    @handleAlienMovement()

  handleAlienMovement: ->
    if @alienMoveCounter
      @alienMoveCounter--
    else
      @alienMoveCounter = @alienMoveInterval
      if @aliensMovingOutsideScreen()
        alien.descend() for alien in @aliens
      else
        alien.advance() for alien in @aliens

  aliensMovingOutsideScreen: ->
    (@rightmostAlien.direction == 'w' and (@rightmostAlien.x - AlienConstants.HORIZONTAL_SPEED < 0)) or
    (@leftmostAlien.direction == 'e' and
      (@leftmostAlien.x + AlienConstants.WIDTH + AlienConstants.HORIZONTAL_SPEED > Crafty.viewport.width))

