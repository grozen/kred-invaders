(function() {
  Crafty.sprite(imageFileAssetHashNameMap['shell'], {
    shellSprite: [0, 0, 7, 10]
  });

  Crafty.c("PlayerShot", {
    init: function() {
      this.requires("2D, DOM, shellSprite, Collision");
      this.stop();
      return this.checkHits('Alien, Ship, Shield, AlienShot, Spaceship');
    },
    fireFrom: function(x, y) {
      this.attr({
        x: x,
        y: y,
        visible: true
      });
      this.bind("EnterFrame", this.advance);
      this.active = true;
      return this;
    },
    advance: function() {
      this.move('n', PlayerConstants.SHOT_SPEED);
      if (this.outsidePlayfield()) {
        this.stop();
      }
      return this;
    },
    stop: function() {
      this.attr({
        x: PlayerConstants.SHOT_IDLE_X,
        y: PlayerConstants.SHOT_IDLE_Y,
        visible: false
      });
      this.unbind("EnterFrame", this.advance);
      this.active = false;
      Crafty.trigger("ShotStopped", this);
      return this;
    },
    isActive: function() {
      return this.active;
    },
    outsidePlayfield: function() {
      return this.y < 0;
    }
  });

}).call(this);
