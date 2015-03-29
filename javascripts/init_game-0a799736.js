(function() {
  $(function() {
    Crafty.init(800, 600);
    Crafty.paths({
      audio: "",
      images: ""
    });
    return Crafty.scene('loading');
  });

}).call(this);
