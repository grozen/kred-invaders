(function() {
  this.ShieldConstants = (function() {
    function ShieldConstants() {}

    ShieldConstants.WIDTH = ShieldConstants.HEIGHT = 12;

    ShieldConstants.IDLE_X = -50;

    ShieldConstants.IDLE_Y = 90;

    return ShieldConstants;

  })();

  Crafty.sprite(ShieldConstants.WIDTH, imageFileAssetHashNameMap['shield'], {
    shieldSprite: [0, 0]
  });

  Crafty.c("Shield", {
    init: function() {
      this.requires("2D, DOM, shieldSprite, SpriteAnimation");
      this.reel("Degrade", 1, 0, 0, 5);
      return this.reel("Degrade");
    },
    shield: function(x, y) {
      this.spawnX = x;
      this.spawnY = y;
      return this;
    },
    degrade: function() {
      this.degradation += 1;
      if (this.degradation >= this.getReel().frames.length) {
        this.attr({
          x: ShieldConstants.IDLE_X,
          y: ShieldConstants.IDLE_Y,
          visible: false
        });
      } else {
        this.reelPosition(this.degradation);
      }
      return this;
    },
    respawn: function() {
      this.degradation = 0;
      this.reelPosition(this.degradation);
      this.attr({
        x: this.spawnX,
        y: this.spawnY,
        visible: true
      });
      return this;
    }
  });

}).call(this);
