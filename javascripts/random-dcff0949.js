(function() {
  this.Random = (function() {
    function Random() {}

    Random.getInRange = function(min, max) {
      return Math.random() * (max - min) + min;
    };

    return Random;

  })();

}).call(this);
