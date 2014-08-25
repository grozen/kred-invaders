class @AlienShotConstants
  @SPEED = 3
  @WIDTH = 5
  @HEIGHT = 16
  @MAX_SHOTS = 8
  @BASE_SHOT_CHANCE = 2
  @ZAP_INTERVAL = 200

Crafty.sprite(AlienShotConstants.WIDTH, AlienShotConstants.HEIGHT, imageFileAssetHashNameMap['alien_shot'],
  alienShot: [0, 0])

Crafty.c "AlienShot",
  init: ->
    @.requires("2D, DOM, alienShot, Collision, SpriteAnimation")

    @.attr(visible: false)
    @.reel("Zap", AlienShotConstants.ZAP_INTERVAL, 0, 0, 2)
    @.checkHits('Player, Shield')

  fireBy: (alien) ->
    x = alien.x + alien.w / 2
    y = alien.y + alien.h
    @.attr(x: x, y: y, visible: true)
    @.animate("Zap", -1)

    @.bind("EnterFrame", @advance)

    @containingNode.remove()
    return @

  advance: ->
    @.move('s', AlienShotConstants.SPEED)
    @stop() if @outsidePlayfield()
    return @

  stop: ->
    @.attr(x: -100, y: 100, visible: false)
    @.pauseAnimation()

    @.unbind("EnterFrame", @advance)

    @containingNode = @containingList.append(@)
    return @

  outsidePlayfield: ->
    @.y > Crafty.viewport.height

  setContainingNode: (shotNode) ->
    @containingNode = shotNode

  setContainingList: (shotList) ->
    @containingList = shotList

  pointsWorth: ->
    25
