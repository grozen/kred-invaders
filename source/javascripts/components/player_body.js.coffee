Crafty.sprite(PlayerConstants.WIDTH, imageFileAssetHashNameMap['player_base'],
  bodySprite: [0, 0])

Crafty.c "PlayerBody",
  init: ->
    @.requires("PlayerCommon, bodySprite, SpriteAnimation, Collision")

    @.reel("MoveRight", PlayerConstants.MOVEMENT_ANIMATION_DURATION, 0, 0, 8)
    @.reel("MoveLeft", PlayerConstants.MOVEMENT_ANIMATION_DURATION, 7, 0, -8)

    @.bind("NewDirection", @changedDirection)

    @currentFrame = 0

  changedDirection: (info) ->
    switch info.x
      when 0
        @.pauseAnimation()
        @currentFrame = @.getReel().currentFrame
      when PlayerConstants.SPEED
        @.animate("MoveRight", -1)
        @.reelPosition(@currentFrame)
      when -PlayerConstants.SPEED
        @.animate("MoveLeft", -1)
        @.reelPosition(@currentFrame)
