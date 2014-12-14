Crafty.c 'Banner',
  init: ->
    @mainText = Crafty.e("2D, DOM, Text")
    @subText = Crafty.e("2D, DOM, Text")

    @mainText.unselectable().textColor('#FFFF00').textFont(size: '40px', family: 'Silkscreen Expanded').css('text-align': 'center')
    @subText.unselectable().textColor('#FFFF00').textFont(size: '28px', family: 'Silkscreen Expanded').css('text-align': 'center')

  show: (text, subText, textWidth, textY, subTextWidth, subTextY) ->
    @mainText.text(text).attr(visible: true, x: Crafty.viewport.width / 2 - textWidth / 2,
                              y: textY, w: textWidth)
    @subText.text(subText).attr(visible: true, x: Crafty.viewport.width / 2 - subTextWidth / 2,
                                y: subTextY, w: subTextWidth)

  hide: ->
    @mainText.attr(visible: false)
    @subText.attr(visible: false)
