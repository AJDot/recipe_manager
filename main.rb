require 'sinatra'
require 'sinatra/content_for'
require 'tilt/erubis'
require 'pry'

require_relative './database_persistence'

##################################################
# FIXME: Refactor Edit Recipe Form
# FIXME: Add New Recipe Form
# FIXME: Add oven_temp and cook_time to database
# FIXME: Space out paragraphs on edit recipe form in textarea
# FIXME: Add Icon Link animation (made on CodePen)
# FIXME: Add Tests for creating and editing recipes
##################################################

configure do
  set :erb, :escape_html => true
end

configure(:development) do
  require 'sinatra/reloader'
  also_reload 'database_persistence.rb'
end

before do
  @storage = DatabasePersistence.new(logger)
end

after do
  @storage.disconnect
end

def data_path
  if ENV['RACK_ENV'] == 'test'
    File.expand_path("../test/public/", __FILE__)
  else
    File.expand_path('../public/', __FILE__)
  end
end

# def recipe_paths
#   paths = Dir.glob(File.join(data_path, "**", "*"))
#   paths.select { |path| File.file?(path) }
# end

def images_path
  File.expand_path("../public/images", __FILE__);
end

def save_image(filename, file_location)
  file_destination = File.join(images_path, filename)
  FileUtils.copy(file_location, file_destination)
end

def get_new_data(params)
  new_image = params[:image][:filename] if params[:image]
  img_filename = new_image || params[:current_image] || nil
  {
    name: params[:name],
    description: params[:description],
    ethnicities: params[:ethnicities].split(/\r?\n/),
    categories: params[:categories].split(/\r?\n/),
    ingredients: params[:ingredients].split(/\r?\n/),
    steps: params[:steps].split(/\r?\n/),
    notes: params[:notes].split(/\r?\n/),
    img_filename: img_filename
  }
end

helpers do
  # Gather values of key from each hash in an array of hashes
  def pluck(array, key)
    array.map { |hash| hash[key] }
  end

  def pluck_on_newlines(array, key)
    pluck(array, key).join('&#13;&#10;')
  end
end

# Display recipe cards
get '/' do

  # new_recipe = {
  #   name: 'Angel Chicken',
  #   description: "Chicken and fresh mushrooms slow-cook in cream cheese, wine and soup. It's easy to put together but tastes like chicken in a complex cream sauce--smooth with delicate seasoning.",
  #   categories: [
  #     'Dinner'
  #   ],
  #   ethniticies: [
  #     'American'
  #   ],
  #   ingredients: [
  #       '4 skinless, boneless chicken breast halves',
  #       '1 Tbsp vegetable oil (optional)',
  #       '8 oz fresh button mushrooms, quartered',
  #       '8 oz fresh shiitake mushrooms, stems removed, caps sliced',
  #       '1/4 cup butter',
  #       '0.7 oz package Italian dry salad dressing mix',
  #       '10 3/4-oz can condensed golden mushroom soup',
  #       '1/2 cup dry white wine',
  #       '4 oz cream cheese spread with chives and onion',
  #       'Hot cooked rice or angel hair pasta',
  #       'Snipped fresh chives or sliced green onions (optional)'
  #   ],
  #   steps: [
  #     'If you like, brown chicken on both sides in a large skillet in hot oil over medium heat. Combine mushrooms in a 3-1/2- or 4-quart slow cooker; top with chicken. Melt butter in a medium saucepan; stir in Italian dressing mix. Stir in mushroom soup, white wine, and cream cheese until melted; pour over chicken.',
  #     'Cover; cook on low-heat setting for 4 to 5 hours.',
  #     'Serve chicken and sauce over cooked rice. Sprinkle with chives, if you like.'
  #   ],
  #   notes: [
  #   ]
  # }

  # @storage.yaml_to_database(*recipe_paths)

  @recipes = @storage.recipes
  all_categories = @storage.all_recipe_categories
  all_images = @storage.all_recipe_images

  @recipes.each do |recipe|
    recipe[:categories] = all_categories.select do |cat|
      recipe[:recipe_id] == cat[:recipe_id]
    end

    image = all_images.find() do |img|
      recipe[:recipe_id] == img[:recipe_id]
    end
    recipe[:img_filename] = image ? image[:img_filename] : image
  end

  erb :index, layout: :layout
end

get '/recipe/create' do
  erb :create_recipe, layout: :layout
end

get '/recipe/:recipe_id' do
  @recipe_id = params[:recipe_id].to_i
  @full_recipe = @storage.full_recipe(@recipe_id)
  @test = {}

  erb :recipe, layout: :layout
end

get '/recipe/:recipe_id/edit' do
  @recipe_id = params[:recipe_id].to_i
  @full_recipe = @storage.full_recipe(@recipe_id)
  erb :edit_recipe, layout: :layout
end

post '/recipe/create' do
  @new_data = get_new_data(params)
  @storage.create_recipe(@new_data)
  new_image = params[:image] if params[:image]
  save_image(new_image[:filename], new_image[:tempfile].path) if new_image

  @recipe_id = @storage.find_recipe_id(@new_data[:name])
  redirect "recipe/#{@recipe_id}"
end

post '/recipe/:recipe_id' do
  @recipe_id = params[:recipe_id].to_i
  new_image = params[:image] if params[:image]
  @new_data = get_new_data(params)
  # @new_data = {
  #   name: params[:name],
  #   description: params[:description],
  #   ethnicities: params[:ethnicities].split(/\r?\n/),
  #   categories: params[:categories].split(/\r?\n/),
  #   ingredients: params[:ingredients].split(/\r?\n/),
  #   steps: params[:steps].split(/\r?\n/),
  #   notes: params[:notes].split(/\r?\n/),
  #   img_filename: (new_image ? new_image[:filename] : params[:current_image])
  # }

  @storage.update_recipe(@recipe_id, @new_data)

  if new_image
    @storage.update_recipe_image(@recipe_id, @new_data[:img_filename])
    save_image(new_image[:filename], new_image[:tempfile].path)
  end

  # @full_recipe = @storage.full_recipe(@recipe_id)
  # erb :recipe
  redirect "/recipe/#{@recipe_id}"
end

post '/recipe/:recipe_id/save_image' do
  recipe_id = params[:recipe_id].to_i
  filename = params[:file][:filename]
  file = params[:file][:tempfile]

  File.open("./public/images/#{filename}", 'wb') do |f|
    f.write(file.read)
  end

  @storage.update_recipe_image(recipe_id, filename)

  redirect "/recipe/#{recipe_id}"
end
