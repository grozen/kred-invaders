(function() {
  this.AlienConstants = (function() {
    function AlienConstants() {}

    AlienConstants.IDLE_X = -200;

    AlienConstants.IDLE_Y = 400;

    AlienConstants.WIDTH = AlienConstants.HEIGHT = 48;

    AlienConstants.HORIZONTAL_SPEED = 10;

    AlienConstants.VERTICAL_SPEED = 25;

    AlienConstants.MOVEMENT_INTERVAL = 2000;

    AlienConstants.HITBOX = {
      1: (function() {
        return [[8, 8], [39, 8], [39, 37], [8, 37]];
      }),
      2: (function() {
        return [[8, 8], [39, 8], [39, 37], [8, 37]];
      }),
      3: (function() {
        return [[8, 8], [39, 8], [39, 37], [8, 37]];
      })
    };

    return AlienConstants;

  })();

  Crafty.sprite(AlienConstants.WIDTH, imageFileAssetHashNameMap['alien1'], {
    alien1: [0, 0]
  });

  Crafty.sprite(AlienConstants.WIDTH, imageFileAssetHashNameMap['alien2'], {
    alien2: [0, 0]
  });

  Crafty.sprite(AlienConstants.WIDTH, imageFileAssetHashNameMap['alien3'], {
    alien3: [0, 0]
  });

  Crafty.c("Alien", {
    init: function() {
      this.requires("2D, DOM, SpriteAnimation, Collision");
      return this.direction = 'w';
    },
    respawn: function() {
      this.attr({
        x: this.spawnX,
        y: this.spawnY,
        visible: true
      });
      this.reelPosition(0);
      this.direction = 'w';
      return this;
    },
    die: function() {
      Crafty.audio.play('alien_die');
      return this.dieSilently();
    },
    dieSilently: function() {
      this.attr({
        x: AlienConstants.IDLE_X,
        y: AlienConstants.IDLE_Y,
        visible: false
      });
      this.node.remove();
      return this;
    },
    alien: function(type, x, y) {
      this.addComponent("alien" + type);
      this.spawnX = x;
      this.spawnY = y;
      this.type = type;
      this.collision(new Crafty.polygon(AlienConstants.HITBOX[type]()));
      this.reel("move", 1, 0, 0, 2);
      this.reel("move");
      return this;
    },
    advance: function() {
      this.move(this.direction, AlienConstants.HORIZONTAL_SPEED);
      this.reelPosition((this.reelPosition() + 1) % 2);
      return this;
    },
    descend: function() {
      this.move('s', AlienConstants.VERTICAL_SPEED);
      if (this.direction === 'w') {
        this.direction = 'e';
      } else {
        this.direction = 'w';
      }
      return this;
    },
    pointsWorth: function() {
      return 50 * this.type;
    },
    setContainingNode: function(node) {
      this.node = node;
      return this;
    }
  });

}).call(this);
