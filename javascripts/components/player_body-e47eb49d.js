(function() {
  Crafty.sprite(PlayerConstants.WIDTH, imageFileAssetHashNameMap['player_base'], {
    bodySprite: [0, 0]
  });

  Crafty.c("PlayerBody", {
    init: function() {
      this.requires("PlayerCommon, bodySprite, SpriteAnimation, Collision");
      this.reel("MoveRight", PlayerConstants.MOVEMENT_ANIMATION_DURATION, 0, 0, 8);
      this.reel("MoveLeft", PlayerConstants.MOVEMENT_ANIMATION_DURATION, 7, 0, -8);
      this.collision(new Crafty.polygon([12, 32], [12, 64], [52, 64], [52, 32]));
      this.checkHits('Alien');
      this.bind("NewDirection", this.changedDirection);
      return this.currentFrame = 0;
    },
    changedDirection: function(info) {
      switch (info.x) {
        case 0:
          this.pauseAnimation();
          return this.currentFrame = this.getReel().currentFrame;
        case PlayerConstants.SPEED:
          this.animate("MoveRight", -1);
          return this.reelPosition(this.currentFrame);
        case -PlayerConstants.SPEED:
          this.animate("MoveLeft", -1);
          return this.reelPosition(this.currentFrame);
      }
    }
  });

}).call(this);
