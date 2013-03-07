Crafty.sprite(PlayerConstants.WIDTH, "images/player_base.png",
  bodySprite: [0, 0])

Crafty.c "PlayerBody",
  init: ->
    @.requires("PlayerCommon, bodySprite, SpriteAnimation")

    @.animate("MoveRight", 0, 0, 7)
    @.animate("MoveLeft", 7, 0, 0)

    @.bind("NewDirection", @changedDirection)

  changedDirection: (info) ->
    switch info.x
      when 0 then @.pause()
      when PlayerConstants.SPEED then @.play("MoveRight", PlayerConstants.MOVEMENT_DURATION, -1)
      when -PlayerConstants.SPEED then @.play("MoveLeft", PlayerConstants.MOVEMENT_DURATION, -1)
