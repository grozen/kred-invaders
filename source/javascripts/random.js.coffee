class @Random
  @getInRange = (min, max) ->
    Math.random() * (max - min) + min
