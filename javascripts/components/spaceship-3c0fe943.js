(function() {
  this.ShipConstants = (function() {
    function ShipConstants() {}

    ShipConstants.SPEED = 4;

    ShipConstants.HEIGHT = 30;

    ShipConstants.WIDTH = 80;

    ShipConstants.FLIGHT_Y = 50;

    ShipConstants.SPAWN_CHANCE_INTERVAL = 5000;

    ShipConstants.SPAWN_CHANCE = 20;

    ShipConstants.IDLE_X = -200;

    ShipConstants.IDLE_Y = 0;

    ShipConstants.MOVEMENT_ANIMATION_DURATION = 250;

    return ShipConstants;

  })();

  Crafty.sprite(ShipConstants.WIDTH, ShipConstants.HEIGHT, imageFileAssetHashNameMap['spaceship_explosion'], {
    spaceshipExplosion: [0, 0]
  });

  Crafty.sprite(ShipConstants.WIDTH, ShipConstants.HEIGHT, imageFileAssetHashNameMap['spaceship'], {
    spaceshipSprite: [0, 0]
  });

  Crafty.c("Spaceship", {
    init: function() {
      this.requires("2D, DOM, SpriteAnimation, Collision, spaceshipSprite");
      this.flying = false;
      this.explosion = Crafty.e('Explosion').explosion('spaceshipExplosion', 3, 1000, 2);
      this.attr({
        x: ShipConstants.IDLE_X,
        y: ShipConstants.IDLE_Y,
        visible: false
      });
      this.reel("MoveRight", ShipConstants.MOVEMENT_ANIMATION_DURATION, 0, 0, 12);
      return this.reel("MoveLeft", ShipConstants.MOVEMENT_ANIMATION_DURATION, 11, 0, -12);
    },
    pointsWorth: function(playerShot) {
      var distanceFromCenter, factor, hitRelativeX;
      hitRelativeX = playerShot._x + playerShot._w / 2 - this._x;
      distanceFromCenter = Math.abs(this._w / 2 - hitRelativeX);
      factor = (function() {
        switch (false) {
          case !(distanceFromCenter < 13):
            return 10;
          case !(distanceFromCenter < 26):
            return 7;
          default:
            return 4;
        }
      })();
      return factor * 50;
    },
    destroy: function(pointsGained) {
      this.explosion.explosionText("" + pointsGained, '#FFFFFF', 10).explodeAt(this.x, this.y);
      Crafty.audio.play("ship_hit");
      return this.hide();
    },
    hide: function() {
      this.attr({
        x: ShipConstants.IDLE_X,
        y: ShipConstants.IDLE_Y,
        visible: false
      });
      this.pauseAnimation();
      this.unbind("EnterFrame", this.advance);
      Crafty.audio.stop("ship_fly");
      this.flying = false;
      return this;
    },
    flyTowards: function(direction) {
      this.direction = direction;
      this.flying = true;
      switch (direction) {
        case 'w':
          this.animate("MoveLeft", -1);
          this.attr({
            x: Crafty.viewport.width,
            y: ShipConstants.FLIGHT_Y,
            visible: true
          });
          break;
        default:
          this.animate("MoveRight", -1);
          this.attr({
            x: -ShipConstants.WIDTH,
            y: ShipConstants.FLIGHT_Y,
            visible: true
          });
      }
      this.bind("EnterFrame", this.advance);
      Crafty.audio.play("ship_fly", -1);
      return this;
    },
    advance: function() {
      this.move(this.direction, ShipConstants.SPEED);
      if (this.outsidePlayfield()) {
        return this.hide();
      }
    },
    outsidePlayfield: function() {
      return this.x > Crafty.viewport.width || this.x < -ShipConstants.WIDTH;
    },
    isFlying: function() {
      return this.flying;
    }
  });

}).call(this);
