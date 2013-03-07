Crafty.sprite(PlayerConstants.WIDTH, "images/player_cannon.png",
  cannonSprite: [0, 0])

Crafty.c "PlayerCannon",
  init: ->
    @.requires("PlayerCommon, cannonSprite, SpriteAnimation")

    @.animate("Fire", 0, 0, 6)
    @.animate("Load", 6, 0, 0)
