Crafty.sprite(PlayerConstants.WIDTH, imageFileAssetHashNameMap['player_cannon'],
  cannonSprite: [0, 0])

Crafty.c "PlayerCannon",
  init: ->
    @.requires("PlayerCommon, cannonSprite, SpriteAnimation")

    @.reel("Fire", PlayerConstants.FIRE_ANIMATION_DURATION, 0, 0, 7)
    @.reel("Reload", PlayerConstants.RELOAD_ANIMATION_DURATION, 0, 0, -7)

    @.bind("AnimationEnd", @reload)

  fire: ->
    @.animate("Fire")

  reload: (reel) ->
    @.animate("Reload") if reel.id == "Fire"
