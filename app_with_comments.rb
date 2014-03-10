require "sinatra"
require "active_record"
require "pg"

# database = PG.connect( dbname: "photo_galleries")
ActiveRecord::Base.establish_connection({
  adapter: 'postgresql',
  database: 'photo_galleries'
  })

class Gallery < ActiveRecord::Base  #::name spacing.  Prevents problem if there was more than one "base"
# class Gallery now inherits from ActiveRecord::Base, which is the databse
# no need to write an initialize method
  has_many :images  #will look for images where gallery :id.  images must be named images
end

class Image < ActiveRecord::Base
end
#two classes because we are mapping to the two tables Galleries & Images
#ALL CLASS NAMES HAVE TO BE SINGULAR!!!
#ALL CLASS NAMES HAVE TO BE SINGULAR!!!
#ALL CLASS NAMES HAVE TO BE SINGULAR!!!
#ALL CLASS NAMES HAVE TO BE SINGULAR!!!


# GALLERIES = {
#   cats: %w(colonel_meow.jpg grumpy_cat.png),
#   dogs: %w(shibe.png)
# }

get "/" do  #'/' is the route path
  @galleries = Gallery.all
  erb :index  
end 

get "/galleries/:id" do
  gallery = Gallery.find(params[:id])
  @title = gallery.name
  @images = gallery.images
  erb :gallery
end

# get "/galleries/:id" do #here ":id" is the path after /galleries/
#   @id = params[:id]
#   #vv returns a hash were the columns are the elements of the hash
#   gallery = database.exec_params(
#     "SELECT * FROM galleries WHERE id = $1", 
#     [@id]
#     ).first
#   @title = gallery["name"]
#   images = database.exec_params(
#     "SELECT * FROM images WHERE gallery_id = $1", 
#     [@id]
#     )
#   @images = images.map { |image| image["url"] }
#   erb :gallery

# get "/galleries/:gallery_name" do
#   @title = params[:gallery_name]
#   @images = GALLERIES[@title.to_sym]
#   erb :gallery