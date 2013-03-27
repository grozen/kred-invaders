class @AlienConstants
  @WIDTH = @HEIGHT = 48
  @HORIZONTAL_SPEED = 4
  @VERTICAL_SPEED = 10

Crafty.sprite(AlienConstants.WIDTH, "images/aliens.png",
  alienSprite1: [0, 0])

Crafty.c "Alien",
  init: ->
    @.requires("2D, DOM, Collision")
    @direction = 'w'

  alien: (type, x, y) ->
    @.addComponent("alienSprite#{type}")
    @.attr(x: x, y: y)

  advance: ->
    @.move(@direction, AlienConstants.HORIZONTAL_SPEED)

  descend: ->
    @.move('s', AlienConstants.VERTICAL_SPEED)
    if @direction is 'w' then @direction = 'e' else @direction = 'w'
