(function() {
  this.PlayerLifeConstants = (function() {
    function PlayerLifeConstants() {}

    PlayerLifeConstants.WIDTH = 25;

    PlayerLifeConstants.HEIGHT = 23;

    PlayerLifeConstants.MARGIN_Y = 20;

    PlayerLifeConstants.MARGIN_X = 20;

    PlayerLifeConstants.MAX_LIVES = 10;

    PlayerLifeConstants.INITIAL_LIVES = 3;

    return PlayerLifeConstants;

  })();

  Crafty.sprite(imageFileAssetHashNameMap['player_life'], {
    playerLife: [0, 0, PlayerLifeConstants.WIDTH, PlayerLifeConstants.HEIGHT]
  });

  Crafty.c('Lives', {
    init: function() {
      var i;
      this.lives = PlayerLifeConstants.INITIAL_LIVES;
      this.sprites = (function() {
        var j, ref, results;
        results = [];
        for (i = j = 1, ref = PlayerLifeConstants.MAX_LIVES; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
          results.push(Crafty.e("playerLife, 2D, DOM").attr({
            x: Crafty.viewport.width - PlayerLifeConstants.MARGIN_X - PlayerLifeConstants.WIDTH * i,
            y: PlayerLifeConstants.MARGIN_Y,
            visible: true
          }));
        }
        return results;
      })();
      return this.updateVisibility();
    },
    lifeUp: function() {
      if (this.lives < PlayerLifeConstants.MAX_LIVES) {
        this.lives += 1;
      }
      return this.updateVisibility();
    },
    lifeDown: function() {
      if (this.lives > 0) {
        this.lives -= 1;
      }
      return this.updateVisibility();
    },
    deplete: function() {
      this.lives = 0;
      return this.updateVisibility();
    },
    updateVisibility: function() {
      var i, j, k, ref, ref1, ref2, results;
      if (this.lives > 0) {
        for (i = j = 0, ref = this.lives - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
          this.sprites[i].attr({
            visible: true
          });
        }
      }
      if (this.lives < PlayerLifeConstants.MAX_LIVES) {
        results = [];
        for (i = k = ref1 = this.lives, ref2 = PlayerLifeConstants.MAX_LIVES - 1; ref1 <= ref2 ? k <= ref2 : k >= ref2; i = ref1 <= ref2 ? ++k : --k) {
          results.push(this.sprites[i].attr({
            visible: false
          }));
        }
        return results;
      }
    },
    reset: function() {
      this.lives = PlayerLifeConstants.INITIAL_LIVES;
      return this.updateVisibility();
    }
  });

}).call(this);
