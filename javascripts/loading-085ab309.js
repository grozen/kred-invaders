(function() {
  Crafty.scene('loading', function() {
    Crafty.load(assets, function() {
      return $script(asyncImportantScripts, function() {
        return $script(asyncScripts, function() {
          return Crafty.scene('playfield');
        });
      });
    });
    return Crafty.background('black');
  });

}).call(this);
