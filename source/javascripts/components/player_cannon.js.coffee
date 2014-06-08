Crafty.sprite(PlayerConstants.WIDTH, imageFileAssetHashNameMap['player_cannon'],
  cannonSprite: [0, 0])

Crafty.c "PlayerCannon",
  init: ->
    @.requires("PlayerCommon, cannonSprite, SpriteAnimation")

    @.animate("Fire", 0, 0, 6)
    @.animate("Load", 6, 0, 0)

    @.bind("AnimationEnd", @reload)

  fire: ->
    @.playAnimation("Fire", 6, 0, 0)

  reload: (info) ->
    @.playAnimation("Load", 16, 0, 0) if info.reelId == "Fire"
