(function() {
  this.PlayerConstants = (function() {
    function PlayerConstants() {}

    PlayerConstants.WIDTH = PlayerConstants.HEIGHT = 64;

    PlayerConstants.SPEED = 3;

    PlayerConstants.MOVEMENT_ANIMATION_DURATION = 250;

    PlayerConstants.FIRE_ANIMATION_DURATION = 300;

    PlayerConstants.RELOAD_ANIMATION_DURATION = 500;

    PlayerConstants.SHOT_SPEED = 8;

    PlayerConstants.SHOT_IDLE_X = -100;

    PlayerConstants.SHOT_IDLE_Y = -100;

    return PlayerConstants;

  })();

  Crafty.c('PlayerCommon', {
    init: function() {
      this.tmp = null;
      this.requires("2D, DOM, Multiway");
      this.multiway(PlayerConstants.SPEED, {
        LEFT_ARROW: 180,
        RIGHT_ARROW: 0
      });
      this.bind("NewDirection", function(info) {
        return this.direction = info;
      });
      return this.bind("Moved", function(info) {
        if (this.movingOutsidePlayfield(info.x, this.direction)) {
          return this.attr({
            x: info.x,
            y: info.y
          });
        }
      });
    },
    movingOutsidePlayfield: function(x, direction) {
      this.tmp = x + direction.x;
      return (this.tmp < 0) || (this.tmp + this._w > Crafty.viewport.width);
    }
  });

}).call(this);
