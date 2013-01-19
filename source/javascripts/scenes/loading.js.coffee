Crafty.scene('loading', ->
  # Load assets as defined in the asset_list_script partial
  Crafty.load(assets, -> Crafty.scene('playfield'))

  Crafty.background('black')
)
