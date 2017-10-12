require 'sinatra'
require 'tilt/erubis'
require 'pry'

require_relative './database_persistence'

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

get '/recipe/:recipe_id' do
  recipe_id = params[:recipe_id].to_i
  @full_recipe = @storage.full_recipe(recipe_id)

  erb :recipe, layout: :layout
end

post '/recipe/:recipe_id/save_image' do
  recipe_id = params[:recipe_id].to_i
  filename = params[:file][:filename]
  file = params[:file][:tempfile]

  File.open("./public/images/#{filename}", 'wb') do |f|
    f.write(file.read)
  end

  @storage.add_image_to_recipe(recipe_id, filename)

  redirect "/recipe/#{recipe_id}"
end
