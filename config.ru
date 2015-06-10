require 'ufrj_tube'

run UfrjTube.new

map '/js' do
  run Rack::Directory.new('./js')
end

map '/images' do
  run Rack::Directory.new('./images')
end

map '/fonts' do
  run Rack::Directory.new('./fonts')
end

map '/css' do
  run Rack::Directory.new('./css')
end

map '/arquivos' do
  run Rack::Directory.new('./arquivos')
end