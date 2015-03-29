(function() {
  Crafty.sprite(PlayerConstants.WIDTH, imageFileAssetHashNameMap['player_cannon'], {
    cannonSprite: [0, 0]
  });

  Crafty.c("PlayerCannon", {
    init: function() {
      this.requires("PlayerCommon, cannonSprite, SpriteAnimation");
      this.reel("Fire", PlayerConstants.FIRE_ANIMATION_DURATION, 0, 0, 7);
      this.reel("Reload", PlayerConstants.RELOAD_ANIMATION_DURATION, 6, 0, -7);
      return this.bind("AnimationEnd", this.reload);
    },
    fire: function() {
      return this.animate("Fire");
    },
    reload: function(reel) {
      if (reel.id === "Fire") {
        return this.animate("Reload");
      }
    }
  });

}).call(this);
