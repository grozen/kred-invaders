set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

activate :relative_assets

activate :asset_hash do |opts|
  opts.exts += %w(.wav .mp3 .ogg)
end

activate :deploy do |deploy|
  deploy.method = :git
end