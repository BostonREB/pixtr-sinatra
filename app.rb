require "sinatra"
require "active_record"
require "pg"

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'photo_galleries'
  )  #where has is last item in method, no need to use curly braces too

class Gallery < ActiveRecord::Base  #table names inferred from class names.  I.e., class Gallery is table galleries
  has_many :images #gives all images with galery_id
end

class Image < ActiveRecord::Base
end

#routs happen from top to bottom vvv

##galleries

get "/" do
  @galleries = Gallery.all  #active record model.  returns array of gallery objects
  erb :index  #erb is a function that runs the file "index.erb"
end

# Gallery.all returns array of galleries [gallery, gallery, gallery] 
# set to instance variable "@galleries" so it can be used in erb.

post "/galleries" do
  gallery = Gallery.create(params[:gallery]) #creates and saves a new gallery object with the attributes of Gallery.  Just a ruby object.  Does not update databse
  #nothing being done outside of method, i.e., rendering erb, so only a local variable
  redirect = "/galleries/#{gallery.id}"
end


get "/galleries/new" do
  erb :new_gallery
end

get "/galleries/:id" do  #makes url dynamic.  Don't have to write each url.
  @gallery = Gallery.find(params[:id]) #finds all records with id from the hash params which pulled it from the string in the get request, the URL
  @images = @gallery.images #selects all images where gallery_id is what was returned 
  erb :gallery  #renders the view gallery.erb 
end

get "/galleries/:id/edit" do
  @gallery = Gallery.find(params[:id])
  erb :edit_gallery
end

patch "/galleries/:id" do
  gallery = Gallery.find(params[:id])  #nothing being done outside of method, i.e., rendering erb, so only a local variable
  gallery.update(params[:gallery])  #creates universal interface updates galleries
  redirect "/galleries/#{gallery.id}"
end

delete "/galleries/:id" do
  gallery = Gallery.find(params[:id])
  gallery.destroy
  redirect "/"
end

##Images
get "/galleries/:gallery_id/images/new" do #needs gallery id so that it knows what gallery each image is associated with.
  @gallery = Gallery.find(params[:gallery_id])
  erb :new_image
end

post "/galleries/:gallery_id/images" do
  # image = Image.new(params[:image])
  gallery = Gallery.find(params[:gallery_id])
  # gallery.images << image
  gallery.images.create(params[:image])
  #calling .create of record not on the image.  puts image into image gallery pulled in my params
  # same as gallery.images << Image.new(params[:image])
  # .create saves to the database  .new does not.
  redirect "/galleries/#{gallery.id}"
end

get "/galleries/:gallery_id/images/:id/edit" do
  @gallery = Gallery.find(params[:gallery_id])
  @image = @gallery.images.find(params[:id]) #better security as you make sure image blelongs to gallery_id
  erb :edit_image
end

patch "/galleries/:gallery_id/images/:id" do
  gallery = Gallery.find(params[:gallery_id])
  image = gallery.images.find(params[:id])  #more secure because it's specific imiage in specific gallery
  image.update(params[:image])
  redirect "/galleries/#{gallery.id}"
end

delete "/galleries/:gallery_id/images/:id" do
  gallery = Gallery.find(params[:gallery_id]) ##no need to reference gallery _id since image id is unique
  image = gallery.images.find(params[:id])
  image.destroy
  redirect "/galleries/#{gallery.id}"
end

# delete "images/:id" do
#   image = Image.find(params[:id])
#   gallery_id = image_gallery_id
#   image.destroy
#   redirect "/images"
#end


