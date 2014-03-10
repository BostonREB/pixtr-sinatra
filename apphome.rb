require "sinatra"
require "active_record"
require "pg"

ActiveRecord::Base.establish_connection({
  adapter: 'postgresql',
  database: 'photo_galleries'
  })

class Gallery < ActiveRecord::Base  
  has_many :images 
end

class Image < ActiveRecord::Base
end


get "/" do
  @galleries = Gallery.all
  erb :test  
end 

# get "/name/:name" do 
#   @name = params[:name]
#   erb :test
# end

get "/galleries/:pics" do
  gallery = Gallery.find(params[:pics])
  @images = gallery.images
  erb :test
end

# get "/galleries/:id" do
#   gallery = Gallery.find(params[:id])
#   @title = gallery.name
#   @images = gallery.images
#   erb :gallery
# end