Crafty.sprite(PlayerConstants.WIDTH, "images/player_cannon.png",
  cannonSprite: [0, 0])

Crafty.c "PlayerCannon",
  init: ->
    @.requires("PlayerCommon, cannonSprite, SpriteAnimation")

    @.animate("Fire", 0, 0, 6)
    @.animate("Load", 6, 0, 0)

    @.bind("AnimationEnd", @reload)

  fire: ->
    @.play("Fire", 6, 0, 0)

  reload: (info) ->
    @.play("Load", 16, 0, 0) if info.reelId == "Fire"
