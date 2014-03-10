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
  erb :index  
end 

# get "/:images" do 
#   @name = params[:name]
#   erb :test
# end

get "/:pics" do
  gallery = Gallery.find(params[:pics])
  @pics = gallery.images
  erb :test
end