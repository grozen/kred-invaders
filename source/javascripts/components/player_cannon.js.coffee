Crafty.sprite(PlayerConstants.WIDTH, "images/player_cannon.png",
  cannonSprite: [0, 0])

Crafty.c "PlayerCannon",
  init: ->
    @.requires("PlayerCommon, cannonSprite, SpriteAnimation")

    @.animate("Fire", 0, 0, 6)
    @.animate("Load", 6, 0, 0)

    @.bind("AnimationEnd", @reload)

  fire: ->
    @.play("Fire", 8, 0, 0) unless @.isPlaying()

  reload: (info) ->
    @.play("Load", 20, 0, 0) if info.reelId == "Fire"
