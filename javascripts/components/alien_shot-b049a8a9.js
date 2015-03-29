(function() {
  this.AlienShotConstants = (function() {
    function AlienShotConstants() {}

    AlienShotConstants.SPEED = 3;

    AlienShotConstants.WIDTH = 5;

    AlienShotConstants.HEIGHT = 16;

    AlienShotConstants.MAX_SHOTS = 8;

    AlienShotConstants.BASE_SHOT_CHANCE = 2;

    AlienShotConstants.ZAP_INTERVAL = 200;

    AlienShotConstants.SHOT_IDLE_X = -100;

    AlienShotConstants.SHOT_IDLE_Y = 100;

    return AlienShotConstants;

  })();

  Crafty.sprite(AlienShotConstants.WIDTH, AlienShotConstants.HEIGHT, imageFileAssetHashNameMap['alien_shot'], {
    alienShot: [0, 0]
  });

  Crafty.c("AlienShot", {
    init: function() {
      this.requires("2D, DOM, alienShot, Collision, SpriteAnimation");
      this.attr({
        visible: false
      });
      this.reel("Zap", AlienShotConstants.ZAP_INTERVAL, 0, 0, 2);
      this.checkHits('PlayerBody, Shield');
      this.shotHit = (function(_this) {
        return function(hitInfo) {
          var target;
          target = hitInfo[0].obj;
          if (target.has('Shield')) {
            _this.trigger('ShieldHit', target);
          }
          if (target.has('PlayerBody')) {
            _this.trigger('PlayerHit', target);
          }
          return _this.stop();
        };
      })(this);
      this.bind("HitOn", this.shotHit);
      this.containingNode = null;
      this.containingList = null;
      return this.fired = false;
    },
    fireBy: function(alien) {
      var x, y;
      x = alien.x + alien.w / 2;
      y = alien.y + alien.h;
      this.attr({
        x: x,
        y: y,
        visible: true
      });
      this.animate("Zap", -1);
      this.bind("EnterFrame", this.advance);
      this.containingNode.remove();
      this.fired = true;
      return this;
    },
    advance: function() {
      this.move('s', AlienShotConstants.SPEED);
      if (this.outsidePlayfield()) {
        this.stop();
      }
      return this;
    },
    die: function() {
      Crafty.audio.play("alien_shot_hit");
      return this.stop();
    },
    stop: function() {
      this.attr({
        x: AlienShotConstants.SHOT_IDLE_X,
        y: AlienShotConstants.SHOT_IDLE_Y,
        visible: false
      });
      this.pauseAnimation();
      this.unbind("EnterFrame", this.advance);
      if (this.fired === true) {
        this.containingNode = this.containingList.append(this);
        this.fired = false;
      }
      return this;
    },
    outsidePlayfield: function() {
      return this.y > Crafty.viewport.height;
    },
    setContainingNode: function(shotNode) {
      return this.containingNode = shotNode;
    },
    setContainingList: function(shotList) {
      return this.containingList = shotList;
    },
    pointsWorth: function() {
      return 25;
    }
  });

}).call(this);
