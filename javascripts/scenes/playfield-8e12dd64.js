(function() {
  Crafty.scene('playfield', function() {
    var game;
    Crafty.background('rgb(32, 55, 67)');
    game = new Game();
    return Crafty.bind("EnterFrame", game.update);
  });

}).call(this);
