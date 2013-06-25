Crafty.c 'Score',
  init: ->
    @score = 0

    @.requires("2D, DOM, Text")
    @.attr(x: 20, y: 20, w: 400).css('text-align': 'left')
    @.text(@getText).unselectable().textColor('#FFFF00').textFont(size: '14px')

  addScore: (add) ->
    @score += add
    @updateText

  getText: ->
    "Score: #{@score}"
