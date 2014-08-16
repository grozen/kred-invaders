class @AlienConstants
  @WIDTH = @HEIGHT = 48
  @HORIZONTAL_SPEED = 10
  @VERTICAL_SPEED = 25
  @MOVEMENT_INTERVAL = 2000

Crafty.sprite(AlienConstants.WIDTH, imageFileAssetHashNameMap['alien1'], alien1: [0, 0])

Crafty.c "Alien",
  init: ->
    @.requires("2D, DOM, SpriteAnimation")
    @direction = 'w'

  remove: ->
    @node.remove()

  # There are 3 alien types, 1-3
  alien: (type, x, y, index) ->
    @.addComponent("alien#{type}")
    @.attr(x: x, y: y)
    @index = index
    @type = type

    @.reel("move", 1, 0, 0, 2)
    @.reel("move")

    return @

  advance: ->
    @.move(@direction, AlienConstants.HORIZONTAL_SPEED)
    @.reelPosition((@.reelPosition() + 1) % 2)

  descend: ->
    @.move('s', AlienConstants.VERTICAL_SPEED)
    if @direction is 'w' then @direction = 'e' else @direction = 'w'

  pointsWorth: ->
    50 * @type

  setContainingNode: (node) ->
    @node = node
