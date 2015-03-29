(function() {
  Crafty.c('Banner', {
    init: function() {
      var bannerZ;
      bannerZ = 20;
      this.mainText = Crafty.e("2D, DOM, Text");
      this.subText = Crafty.e("2D, DOM, Text");
      this.mainText.unselectable().textColor('#FFFF00').textFont({
        size: '48px',
        family: 'Silkscreen Expanded'
      }).css({
        'text-align': 'center'
      });
      this.subText.unselectable().textColor('#FFFF00').textFont({
        size: '28px',
        family: 'Silkscreen Expanded'
      }).css({
        'text-align': 'center'
      });
      this.mainText.z = bannerZ;
      return this.subText.z = bannerZ;
    },
    show: function(text, subText, textWidth, textY, subTextWidth, subTextY) {
      this.mainText.attr({
        visible: true,
        x: Crafty.viewport.width / 2 - textWidth / 2,
        y: textY,
        w: textWidth
      }).text(text);
      return this.subText.attr({
        visible: true,
        x: Crafty.viewport.width / 2 - subTextWidth / 2,
        y: subTextY,
        w: subTextWidth
      }).text(subText);
    },
    hide: function() {
      this.mainText.attr({
        visible: false
      });
      return this.subText.attr({
        visible: false
      });
    }
  });

}).call(this);
