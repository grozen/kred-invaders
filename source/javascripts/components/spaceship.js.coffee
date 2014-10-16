class @ShipConstants
  @SPEED = 4
  @HEIGHT = 30
  @WIDTH = 78
  @FLIGHT_Y = 50
  @SPAWN_CHANCE_INTERVAL = 5000
  @SPAWN_CHANCE = 20
  @IDLE_X = -200
  @IDLE_Y = 0

Crafty.sprite(ShipConstants.WIDTH, ShipConstants.HEIGHT, imageFileAssetHashNameMap['spaceship'], spaceshipSprite: [0, 0])

Crafty.c "Spaceship",
  init: ->
    @.requires("2D, DOM, SpriteAnimation, Collision, WiredHitBox, spaceshipSprite")
    @flying = false

  pointsWorth: (playerShot) ->
    hitRelativeX = playerShot._x + playerShot._w / 2 - @._x
    distanceFromCenter = Math.abs(@._w / 2 - hitRelativeX)

    factor = switch
      when distanceFromCenter < 13 then 10
      when distanceFromCenter < 26 then 7
      else 4

    factor * 50

  destroy: ->
    @.attr(x: ShipConstants.IDLE_X, y: ShipConstants.IDLE_Y, visible: false)
    #TODO: Pause animation when there is one
    @.unbind("EnterFrame", @advance)
    @flying = false

    return @

  flyTowards: (direction) ->
    @direction = direction
    @flying = true

    switch direction
      when 'w'
        @.attr(x: Crafty.viewport.width, y: ShipConstants.FLIGHT_Y, visible: true)
      else
        @.attr(x: -ShipConstants.WIDTH, y: ShipConstants.FLIGHT_Y, visible: true)

    @.bind("EnterFrame", @advance)
    #TODO: Start animation when there is one

    return @

  advance: ->
    @.move(@direction, ShipConstants.SPEED)
    @destroy() if @outsidePlayfield()

  outsidePlayfield: ->
    @.x > Crafty.viewport.width || @.x < -ShipConstants.WIDTH

  isFlying: ->
    return @flying
