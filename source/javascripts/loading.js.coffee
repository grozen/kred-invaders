Crafty.scene 'loading', ->
  # Load assets as defined in the asset_list_script partial, then load all async
  # scripts as defined in the same partial.
  Crafty.load(assets, ->
    $script(async_scripts, ->
      Crafty.scene('playfield')))

  Crafty.background('black')
