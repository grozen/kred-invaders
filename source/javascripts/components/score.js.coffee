class @ScoreConstants
  @MARGIN_Y = 20
  @MARGIN_X = 20
  @LIFE_GAIN_SCORE = 2500

Crafty.c 'Score',
  init: ->
    @score = 0

    @.requires("2D, DOM, Text")
    @.attr(x: ScoreConstants.MARGIN_X, y: ScoreConstants.MARGIN_Y, w: 400).css('text-align': 'left')
    @.updateText().unselectable().textColor('#FFFF00').textFont(size: '20px', family: 'Silkscreen Expanded')

  reset: ->
    @score = 0
    @updateText()

  addScore: (add) ->
    @.trigger("LifeIncrement", @) if Math.floor((@score + add) / ScoreConstants.LIFE_GAIN_SCORE) > Math.floor(@score / ScoreConstants.LIFE_GAIN_SCORE)
    @score += add
    @updateText()

  updateText: ->
    @.text("Score: #{@score}")

  getScore: ->
    @score
