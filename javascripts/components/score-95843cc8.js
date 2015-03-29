(function() {
  this.ScoreConstants = (function() {
    function ScoreConstants() {}

    ScoreConstants.MARGIN_Y = 20;

    ScoreConstants.MARGIN_X = 20;

    ScoreConstants.LIFE_GAIN_SCORE = 2500;

    return ScoreConstants;

  })();

  Crafty.c('Score', {
    init: function() {
      this.score = 0;
      this.requires("2D, DOM, Text");
      this.attr({
        x: ScoreConstants.MARGIN_X,
        y: ScoreConstants.MARGIN_Y,
        w: 400
      }).css({
        'text-align': 'left'
      });
      return this.updateText().unselectable().textColor('#FFFF00').textFont({
        size: '20px',
        family: 'Silkscreen Expanded'
      });
    },
    reset: function() {
      this.score = 0;
      return this.updateText();
    },
    addScore: function(add) {
      if (Math.floor((this.score + add) / ScoreConstants.LIFE_GAIN_SCORE) > Math.floor(this.score / ScoreConstants.LIFE_GAIN_SCORE)) {
        this.trigger("LifeIncrement", this);
      }
      this.score += add;
      return this.updateText();
    },
    updateText: function() {
      return this.text("Score: " + this.score);
    },
    getScore: function() {
      return this.score;
    }
  });

}).call(this);
