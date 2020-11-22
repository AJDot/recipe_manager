require_relative 'config/initializers/dotenv'
require_relative 'config/initializers/carrierwave'
require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/activerecord'
require 'tilt/erubis'
require 'pry'

require_relative 'lib/cook_time'
require_relative 'lib/recipe'
require_relative 'lib/core_ext/object'
require_relative 'lib/authentication'
require_relative 'lib/user'

################################################################################
# TODO: 5 row max height on ethnicities, categories, description
# TODO: remove transition time for resizing textareas
# TODO: Add oven_temp to database
# TODO: Add prep_time to database
# TODO: Write tests for cook_time inputs and errors
# TODO: Use JS once learned? Scale recipes
# TODO: Use JS once learned? Find or create function to scale numbers and output most appropriate form of number (given units of number)
# COMPLETE: Use JS once learned? Add 'Are you sure?' to any destructive action (deleting a recipe, etc)
# COMPLETE: Add "uncategorized" option in filter by category feature
# COMPLETE: Refactored JS structure to be more organized.
# COMPLETE: Use JS once learned? Add recipe card filter feature
# COMPLETE: Use JS once learned? Add feature to 'complete' ingredients and directions
################################################################################

configure do
  enable :sessions
  set :session_secret, 'secret'
  set :erb, :escape_html => true
  set :public_folder, "#{__dir__}/public"
end

configure(:development) do
  require 'sinatra/reloader'
  also_reload 'lib/**/*'
  set :static_cache_control, :no_cache
end

configure(:test) do
  set :static_cache_control, :no_cache
end

configure(:production) do
  set :static_cache_control, [:public, max_age: 1.year.to_i]
end

def save_image(filename, file_location)
  file_destination = File.join(data_path, 'images', filename)
  FileUtils.copy(file_location, file_destination)
end

def get_recipe_form_data(params)
  {
    name: params[:name].strip,
    description: params[:description],
    cook_time: hh_mm_to_cook_time(params[:hours], params[:minutes]),
    note: params[:note],
    image: params[:image],
  }
end

def split_lines(string)
  string.each_line.map(&:strip)
end

def process_detail(detail)
  detail && detail.split(/(?:\r?\n)+/).uniq
end

def load_recipe(id)
  recipe = Recipe.find_by(id: id)
  return recipe unless recipe.nil?

  session[:error] = "The specified recipe was not found."
  status 422
  redirect "/"
  halt
end

helpers Authentication
helpers do
  def redirect_to_original_request
    session[:success] = "Welcome back #{current_user.email}."
    original_request = session[:original_request]
    session[:original_request] = nil
    redirect original_request
  end

  # Gather values of key from each hash in an array of hashes
  def pluck(array, key)
    array.map { |hash| hash[key] }
  end

  def on_newlines(array)
    array.join('&#13;&#10;')
  end

  def sort_by_name(recipes)
    # recipes.sort_by(&:name)
    recipes.sort do |a, b|
      a.name.upcase <=> b.name.upcase
    end
  end

  def make_link(text)
    return '' if text.blank?
    # Barely tested regex to pick out URLs
    url_regex = /(\bhttps?.+?(?=\.?\s|[,:]|$))/
    text.gsub(url_regex, '<a href="\1" target="_blank">\1</a>')
  end

  def hh_mm_to_cook_time(hours, minutes)
    hours.to_s.rjust(2, '0') + ':' + minutes.to_s.rjust(2, '0')
  end

  def add_details(recipe, params)
    add_recipe_categories(recipe, process_detail(params[:categories]))
    add_recipe_ethnicities(recipe, process_detail(params[:ethnicities]))
    add_recipe_steps(recipe, process_detail(params[:steps]))
    add_recipe_ingredients(recipe, process_detail(params[:ingredients]))
  end

  def add_categories(cat_names)
    Array.wrap(cat_names).map { |cat_name| Category.find_or_create_by(name: cat_name) }
  end

  def add_recipe_categories(recipe, cat_names)
    recipe.categories = add_categories(Array.wrap(cat_names))
  end

  def add_ethnicities(eth_names)
    Array.wrap(eth_names).map { |eth_name| Ethnicity.find_or_create_by(name: eth_name) }
  end

  def add_recipe_ethnicities(recipe, eth_names)
    recipe.ethnicities = add_ethnicities(Array.wrap(eth_names))
  end

  def add_steps(step_descriptions, recipe)
    Array.wrap(step_descriptions).map do |desc|
      Step.find_or_create_by(description: desc)
    end
  end

  def add_recipe_steps(recipe, step_descriptions)
    recipe.steps = add_steps(Array.wrap(step_descriptions), recipe)
  end

  def add_ingredients(ingredient_descriptions, recipe)
    Array.wrap(ingredient_descriptions).map do |desc|
      Ingredient.find_or_create_by(description: desc)
    end
  end

  def add_recipe_ingredients(recipe, ingredient_descriptions)
    recipe.ingredients = add_ingredients(Array.wrap(ingredient_descriptions), recipe)
  end

  def add_image(image_params)
    Image.build(image_params)
  end

  def add_recipe_image(recipe, image_params)
    return if image_params.nil?
    recipe.image = image_params
  end
end

# View recipe cards
get '/' do
  authenticate!
  @recipes = Recipe.all
  erb :index, layout: :layout
end

get '/sign_in/?' do
  if current_user?
    session[:notice] = 'Already signed in.'
    redirect '/'
  end
  erb :sign_in, locals: {title: 'Sign In'}
end

post '/sign_in/?' do
  user = User.authenticate(params)
  if user.present?
    self.current_user = user
    redirect_to_original_request
  else
    session[:error] = 'You could not be signed in. Did you enter the correct email and password?'
    erb :sign_in, locals: {title: 'Sign In'}
  end
end

get '/sign_out' do
  self.current_user = nil
  session[:success] = 'You have been signed out.'
  redirect '/'
end

get '/sign_up/?' do
  erb :sign_up, locals: {title: 'Sign Up'}
end

post '/sign_up' do
  user = User.new(params.slice('email', 'password', 'password_confirmation'))
  if user.save
    self.current_user = user
    session[:success] = "Welcome #{current_user.email}."
    redirect '/'
  else
    session[:error] = user.errors.full_messages
    erb :sign_up, locals: {title: 'Sign Up'}
  end
end

# View create recipe form
get '/recipe/create' do
  authenticate!
  erb :create_recipe, layout: :layout
end

# View recipe details
get '/recipe/:id' do
  @recipe_id = params[:id].to_i
  @recipe = load_recipe(params[:id])
  erb :recipe, layout: :layout
end

# View edit recipe form
get '/recipe/:id/edit' do
  authenticate!
  @recipe_id = params[:id].to_i
  @recipe = load_recipe(@recipe_id)
  erb :edit_recipe, layout: :layout
end

# Delete recipe
post '/recipe/:id/destroy' do
  authenticate!
  @recipe_id = params[:id].to_i
  recipe = load_recipe(params[:id])
  if recipe.destroy
    session[:success] = "#{recipe.name} was successfully deleted."
  else
    session[:error] = "Unable to destroy #{recipe.name}."
  end
  redirect '/'
end

# Create new recipe
post '/recipe/create' do
  authenticate!
  @new_data = get_recipe_form_data(params)

  @recipe = Recipe.new(@new_data)
  if @recipe.save
    add_details(@recipe, params)
    session[:success] = "#{@new_data[:name]} was successfully created."
    redirect "recipe/#{@recipe.id}"
  else
    session[:error] = @recipe.errors.full_messages
    status 422
    erb :create_recipe, layout: :layout
  end
end

# Edit recipe
post '/recipe/:id' do
  authenticate!
  @recipe_id = params[:id].to_i
  @new_data = get_recipe_form_data(params)

  @recipe = load_recipe(params[:id])
  if @recipe.update(@new_data)
    add_details(@recipe, params)
    session[:success] = "#{@recipe.name} was successfully updated."
    redirect "/recipe/#{@recipe.id}"
  else
    session[:error] = @recipe.errors.full_messages
    status 422
    erb :edit_recipe, layout: :layout
  end
end
