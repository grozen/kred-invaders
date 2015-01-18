set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

activate :asset_hash do |opts|
  opts.exts += %w(.wav .mp3 .ogg)
end