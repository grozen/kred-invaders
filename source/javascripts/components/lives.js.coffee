class @PlayerLifeConstants
  @WIDTH = 25
  @HEIGHT = 23
  @MARGIN_Y = 20
  @MARGIN_X = 20
  @MAX_LIVES = 10
  @INITIAL_LIVES = 3

Crafty.sprite(imageFileAssetHashNameMap['player_life'], playerLife: [0, 0, PlayerLifeConstants.WIDTH, PlayerLifeConstants.HEIGHT])

Crafty.c 'Lives',
  init: ->
    @lives = PlayerLifeConstants.INITIAL_LIVES

    @sprites = for i in [1..PlayerLifeConstants.MAX_LIVES]
      (Crafty.e("playerLife, 2D, DOM").attr(
        x: Crafty.viewport.width - PlayerLifeConstants.MARGIN_X - PlayerLifeConstants.WIDTH * i
        y: PlayerLifeConstants.MARGIN_Y
        visible: true
      ))

    @updateVisibility()

  lifeUp: ->
    @lives += 1 if @lives < PlayerLifeConstants.MAX_LIVES
    @updateVisibility()

  lifeDown: ->
    @lives -= 1 if @lives > 0
    @updateVisibility()

  deplete: ->
    @lives = 0
    @updateVisibility()

  updateVisibility: ->
    (@sprites[i].attr(visible: true) for i in [0..(@lives - 1)]) if @lives > 0
    (@sprites[i].attr(visible: false) for i in [@lives..(PlayerLifeConstants.MAX_LIVES - 1)]) if @lives < PlayerLifeConstants.MAX_LIVES

  reset: ->
    @lives = PlayerLifeConstants.INITIAL_LIVES
    @updateVisibility()
