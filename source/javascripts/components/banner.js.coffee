Crafty.c 'Banner',
  init: ->
    bannerZ = 20

    @mainText = Crafty.e("2D, DOM, Text")
    @subText = Crafty.e("2D, DOM, Text")

    @mainText.unselectable().textColor('#FFFF00').textFont(size: '48px', family: 'Silkscreen Expanded').css('text-align': 'center')
    @subText.unselectable().textColor('#FFFF00').textFont(size: '28px', family: 'Silkscreen Expanded').css('text-align': 'center')

    @mainText.z = bannerZ
    @subText.z = bannerZ

  show: (text, subText, textWidth, textY, subTextWidth, subTextY) ->
    @mainText.attr(
      visible: true,
      x: Crafty.viewport.width / 2 - textWidth / 2,
      y: textY,
      w: textWidth).text(text)

    @subText.attr(
      visible: true,
      x: Crafty.viewport.width / 2 - subTextWidth / 2,
      y: subTextY,
      w: subTextWidth).text(subText)

  hide: ->
    @mainText.attr(visible: false)
    @subText.attr(visible: false)
