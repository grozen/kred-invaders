class @ShipConstants
  @SPEED = 25
  @HEIGHT = 30
  @WIDTH = 78

Crafty.sprite(ShipConstants.WIDTH, ShipConstants.HEIGHT, imageFileAssetHashNameMap['spaceship'], spaceshipSprite: [0, 0])

Crafty.c "Spaceship",
  init: ->
    @.requires("2D, DOM, SpriteAnimation, Collision, WiredHitBox, spaceshipSprite")

  pointsWorth: (playerShot) ->
    hitRelativeX = playerShot._x + playerShot._w / 2 - @._x
    distanceFromCenter = Math.abs(@._w / 2 - hitRelativeX)

    factor = switch
      when distanceFromCenter < 13 then 10
      when distanceFromCenter < 26 then 7
      else 4

    factor * 50

  destroy: ->
    #@ TODO: Get destroyed
