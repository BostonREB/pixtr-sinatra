require "sinatra"
require "pg"

database = PG.connect( dbname: "photo_galleries")

# GALLERIES = {
#   cats: %w(colonel_meow.jpg grumpy_cat.png),
#   dogs: %w(shibe.png)
# }

get "/" do  #'/' is the route path
  erb :index  
end 

get "/galleries/:id" do #here ":id" is the path after /galleries/
  @id = params[:id]
  #vv returns a hash were the columns are the elements of the hash
  gallery = database.exec_params(
    "SELECT * FROM galleries WHERE id = $1", 
    [@id]
    ).first
  @title = gallery["name"]
  images = database.exec_params(
    "SELECT * FROM images WHERE gallery_id = $1", 
    [@id]
    )
  @images = images.map { |image| image["url"] }
  erb :gallery

# get "/galleries/:gallery_name" do
#   @title = params[:gallery_name]
#   @images = GALLERIES[@title.to_sym]
#   erb :gallery
end