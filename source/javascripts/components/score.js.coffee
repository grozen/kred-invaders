class @ScoreConstants
  @MARGIN_Y = 20
  @MARGIN_X = 20

Crafty.c 'Score',
  init: ->
    @score = 0

    @.requires("2D, DOM, Text")
    @.attr(x: ScoreConstants.MARGIN_X, y: ScoreConstants.MARGIN_Y, w: 400).css('text-align': 'left')
    @.updateText().unselectable().textColor('#FFFF00').textFont(size: '14px')

  addScore: (add) ->
    @score += add
    @updateText()

  getText: ->
    "Score: #{@score}"

  updateText: ->
    @.text(@getText)
