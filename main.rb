require 'sinatra'
require 'sinatra/content_for'
require 'tilt/erubis'
require 'pry'

require_relative './database_persistence'

##################################################
# FIXME: Add success/error feedback for user actions
# FIXME: make a Recipe Class (maybe?)
# FIXME: Add oven_temp and cook_time to database
# FIXME: Add Icon Link animation (made on CodePen)
# FIXME: Scale recipes
# FIXME: Find or create function to scale numbers and output most appropriate form of number (given units of number)
# FIXME: Add recipe card sorting feature
# FIXME: Add recipe card filter feature
# FIXME: Add 'Are you sure?' to any destructive action (deleting a recipe, etc)
# FIXME: Add feature to 'complete' ingredients and directions
##################################################

configure do
  enable :sessions
  set :session_secret, 'secret'
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

def save_image(filename, file_location)
  file_destination = File.join(data_path, 'images', filename)
  FileUtils.copy(file_location, file_destination)
end

def get_recipe_form_data(params)
  new_image = params[:image] && params[:image][:filename]
  img_filename = new_image || params[:current_image]
  {
    name: params[:name].strip,
    description: params[:description],
    ethnicities: process_detail(params[:ethnicities]),
    categories: process_detail(params[:categories]),
    ingredients: process_detail(params[:ingredients]),
    steps: process_detail(params[:steps]),
    notes: process_detail(params[:notes]),
    img_filename: img_filename
  }
end

def process_detail(detail)
  detail && detail.split(/\r?\n/).uniq
end

def recipe_name_error(recipe_id, name)
  recipes = @storage.recipes
  if !(1..100).cover? name.size
    'Recipe name must be between 1 and 100 characters.'
  elsif recipes.any? do |recipe|
          recipe[:name] == name && recipe[:recipe_id] != recipe_id
        end
    'Recipe name must be unique.'
  end
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

# View recipe cards
get '/' do
  @recipes = @storage.recipes
  all_categories = @storage.all_recipes_categories
  all_images = @storage.all_images

  @recipes.each do |recipe|
    recipe[:categories] = all_categories.select do |cat|
      recipe[:recipe_id] == cat[:recipe_id]
    end

    image = all_images.find() do |img|
      recipe[:recipe_id] == img[:recipe_id]
    end
    recipe[:img_filename] = image && image[:img_filename]
  end

  erb :index, layout: :layout
end

# View create recipe form
get '/recipe/create' do
  erb :create_recipe, layout: :layout
end

# View recipe details
get '/recipe/:recipe_id' do
  @recipe_id = params[:recipe_id].to_i
  @full_recipe = @storage.full_recipe(@recipe_id)

  erb :recipe, layout: :layout
end

# View edit recipe form
get '/recipe/:recipe_id/edit' do
  @recipe_id = params[:recipe_id].to_i
  @full_recipe = @storage.full_recipe(@recipe_id)
  erb :edit_recipe, layout: :layout
end

# Delete recipe
post '/recipe/:recipe_id/destroy' do
  @recipe_id = params[:recipe_id].to_i
  @storage.destroy_recipe(@recipe_id)
  session[:success] = "#{params[:name]} was successfully deleted."
  redirect '/'
end

# Create new recipe
post '/recipe/create' do
  @new_data = get_recipe_form_data(params)

  error = recipe_name_error(nil, @new_data[:name])
  if error
    session[:error] = error
    status 422
    erb :create_recipe, layout: :layout
  else
    @storage.create_recipe(@new_data)
    @recipe_id = @storage.find_recipe_id(@new_data[:name])

    new_image = params[:image]
    if new_image
      @storage.update_recipe_image(@recipe_id, @new_data[:img_filename])
      save_image(new_image[:filename], new_image[:tempfile].path)
    end
    session[:success] = "#{@new_data[:name]} was successfully created."
    redirect "recipe/#{@recipe_id}"
  end
end

# Edit recipe
post '/recipe/:recipe_id' do
  @recipe_id = params[:recipe_id].to_i
  @new_data = get_recipe_form_data(params)

  error = recipe_name_error(@recipe_id, @new_data[:name])
  if error
    session[:error] = error
    status 422
    erb :edit_recipe, layout: :layout
  else
    @storage.update_recipe(@recipe_id, @new_data)

    new_image = params[:image]
    if new_image
      @storage.update_recipe_image(@recipe_id, @new_data[:img_filename])
      save_image(new_image[:filename], new_image[:tempfile].path)
    end

    session[:success] = "#{@new_data[:name]} was successfully updated."
    redirect "/recipe/#{@recipe_id}"
  end
end
