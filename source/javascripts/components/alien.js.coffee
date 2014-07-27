class @AlienConstants
  @WIDTH = @HEIGHT = 48
  @HORIZONTAL_SPEED = 10
  @VERTICAL_SPEED = 25
  @MOVEMENT_INTERVAL = 2000

Crafty.sprite(AlienConstants.WIDTH, imageFileAssetHashNameMap['aliens'],
  alienSprite1: [0, 0])

Crafty.c "Alien",
  init: ->
    @.requires("2D, DOM, Collision")
    @direction = 'w'

  # There are 3 alien types, 1-3
  alien: (type, x, y, index) ->
    @.addComponent("alienSprite#{type}")
    @.attr(x: x, y: y)
    @index = index
    @type = type
    return @

  advance: ->
    @.move(@direction, AlienConstants.HORIZONTAL_SPEED)

  descend: ->
    @.move('s', AlienConstants.VERTICAL_SPEED)
    if @direction is 'w' then @direction = 'e' else @direction = 'w'

  pointsWorth: ->
    50 * @type
