class @AlienConstants
  @IDLE_X = -200
  @IDLE_Y = 400
  @WIDTH = @HEIGHT = 48
  @HORIZONTAL_SPEED = 10
  @VERTICAL_SPEED = 25
  @MOVEMENT_INTERVAL = 2000
  @HITBOX = {
              1: (-> [[8,8], [39,8], [39,37], [8,37]]),
              2: (-> [[8,8], [39,8], [39,37], [8,37]]),
              3: (-> [[8,8], [39,8], [39,37], [8,37]])
            }

Crafty.sprite(AlienConstants.WIDTH, imageFileAssetHashNameMap['alien1'], alien1: [0, 0])
Crafty.sprite(AlienConstants.WIDTH, imageFileAssetHashNameMap['alien2'], alien2: [0, 0])
Crafty.sprite(AlienConstants.WIDTH, imageFileAssetHashNameMap['alien3'], alien3: [0, 0])

Crafty.c "Alien",
  init: ->
    @.requires("2D, DOM, SpriteAnimation, Collision, WiredHitBox")
    @direction = 'w'

  respawn: ->
    @.attr(x: @spawnX, y: @spawnY, visible: true)
    @.reelPosition(0)
    @direction = 'w'
    return @

  die: ->
    Crafty.audio.play('alien_die')
    return @.dieSilently()

  dieSilently: ->
    @.attr(x: AlienConstants.IDLE_X, y: AlienConstants.IDLE_Y, visible: false)
    @node.remove()
    return @

  # There are 3 alien types, 1-3
  alien: (type, x, y) ->
    @.addComponent("alien#{type}")

    @spawnX = x
    @spawnY = y

    @type = type

    # AlienConstants.HITBOX actually returns a function you must call and this
    # allows a brand new array each time.
    @.collision(new Crafty.polygon((AlienConstants.HITBOX[type])()))

    @.reel("move", 1, 0, 0, 2)
    @.reel("move")

    return @

  advance: ->
    @.move(@direction, AlienConstants.HORIZONTAL_SPEED)
    @.reelPosition((@.reelPosition() + 1) % 2)
    return @

  descend: ->
    @.move('s', AlienConstants.VERTICAL_SPEED)
    if @direction is 'w' then @direction = 'e' else @direction = 'w'
    return @

  pointsWorth: ->
    50 * @type

  setContainingNode: (node) ->
    @node = node
    return @
