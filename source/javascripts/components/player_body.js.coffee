Crafty.sprite(PlayerConstants.WIDTH, imageFileAssetHashNameMap['player_base'],
  bodySprite: [0, 0])

Crafty.c "PlayerBody",
  init: ->
    @.requires("PlayerCommon, bodySprite, SpriteAnimation")

    @.animate("MoveRight", 0, 0, 7)
    @.animate("MoveLeft", 7, 0, 0)

    @.bind("NewDirection", @changedDirection)

  changedDirection: (info) ->
    switch info.x
      when 0 then @.pauseAnimation()
      when PlayerConstants.SPEED then @.playAnimation("MoveRight", PlayerConstants.MOVEMENT_DURATION, -1)
      when -PlayerConstants.SPEED then @.playAnimation("MoveLeft", PlayerConstants.MOVEMENT_DURATION, -1)
