ENV["RACK_ENV"] = "test"

require 'fileutils'
require 'minitest/autorun'
require 'minitest/reporters'
require 'rack/test'
Minitest::Reporters.use!

require './config/environment'
require 'database_cleaner'
require_relative '../main.rb'
Dir[File.join(Sinatra::Application.root, 'test/support/**/*.rb')].each { |f| require f }
Dir[File.join(Sinatra::Application.root, 'test/factories/**/*.rb')].each { |f| require f }

DatabaseCleaner.strategy = :transaction
DatabaseCleaner.clean_with(:truncation)

class NomNomNotesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def session
    last_request.env["rack.session"]
  end

  def sign_in(user)
    env 'rack.session', {user_id: user.id.to_s}
  end

  def create_user(attrs = {})
    create :user, :default, attrs
  end

  def must_be_signed_in(type, path, body = {})
    send(type, path, body)
    assert_equal 302, last_response.status
    assert_includes last_response.location, '/sign_in'
  end

  def test_view_recipe_cards
    test_cat_name = 'Category 1'
    recipe_data = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1',
      categories: [
        Category.new(name: test_cat_name)
      ]
    }
    Recipe.create(recipe_data)

    must_be_signed_in(:get, "/", recipe_data)
    sign_in(create_user)

    get '/'

    # Display recipe card
    assert_equal 200, last_response.status
    assert_includes last_response.body, recipe_data[:name]
    assert_includes last_response.body, recipe_data[:description]
    assert_includes last_response.body, test_cat_name
    assert_includes last_response.body, 'View Recipe'
  end

  def test_view_recipe_details
    test_cat_name = 'Category 1'
    recipe_data = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1',
      categories: [
        Category.new(name: test_cat_name),
      ]
    }
    recipe = Recipe.create(recipe_data)

    # Display recipe details
    get "/recipe/#{recipe.id}"

    assert_equal 200, last_response.status
    assert_includes last_response.body, recipe_data[:name]
    assert_includes last_response.body, recipe_data[:description]
    assert_includes last_response.body, test_cat_name
  end

  def test_view_recipe_detail_ingredients
    test_ing_info = '1 cup Ingredient 1'
    recipe_data = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1',
      ingredients: [
        Ingredient.new(description: test_ing_info)
      ]
    }
    recipe = Recipe.create(recipe_data)

    # Display recipe details
    get "/recipe/#{recipe.id}"

    assert_equal 200, last_response.status
    assert_includes last_response.body, recipe_data[:name]
    assert_includes last_response.body, recipe_data[:description]
    assert_includes last_response.body, test_ing_info
  end

  def test_view_recipe_detail_ethnicities
    test_eth = 'Ethnicity 1'
    recipe_data = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1',
      cook_time: '00:00',
      ethnicities: [
        Ethnicity.new(name: test_eth),
      ]
    }
    recipe = Recipe.create(recipe_data)

    # Display recipe details
    get "/recipe/#{recipe.id}"

    assert_equal 200, last_response.status
    assert_includes last_response.body, recipe_data[:name]
    assert_includes last_response.body, recipe_data[:description]
    assert_includes last_response.body, test_eth
  end

  def test_view_recipe_detail_steps
    test_step = 'Step 1'
    recipe_data = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1',
      steps: [
        Step.new(description: test_step),
      ]
    }
    recipe = Recipe.create(recipe_data)

    # Display recipe details
    get "/recipe/#{recipe.id}"

    assert_equal 200, last_response.status
    assert_includes last_response.body, recipe_data[:name]
    assert_includes last_response.body, recipe_data[:description]
    assert_includes last_response.body, test_step
  end

  def test_view_recipe_detail_notes
    test_note = 'Note 1'
    recipe_data = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1',
      cook_time: '00:00',
      note: test_note
    }
    recipe = Recipe.create(recipe_data)

    # Display recipe details
    get "/recipe/#{recipe.id}"

    assert_equal 200, last_response.status
    assert_includes last_response.body, recipe_data[:name]
    assert_includes last_response.body, recipe_data[:description]
    assert_includes last_response.body, test_note
  end

  def test_create_recipe
    recipe_data = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1',
      hours: '1',
      minutes: '2',
      ethnicities: "e1\\r\\ne2",
      categories: "c1\\r\\nc2",
      ingredients: "i1\\r\\ni2",
      steps: "s1\\r\\ns2",
      note: "n1\\r\\nn2",
    }

    must_be_signed_in(:post, "/recipe/create", recipe_data)
    sign_in(create_user)

    post "/recipe/create", recipe_data
    assert_equal 302, last_response.status

    get last_response["Location"]
    assert_equal 200, last_response.status
    assert_includes last_response.body, recipe_data[:name]
    assert_includes last_response.body, recipe_data[:description]
    cook_time = "#{recipe_data[:hours]} h #{recipe_data[:minutes]} m"
    assert_includes last_response.body, cook_time
    recipe_data[:ethnicities].split(/\r?\n/).each do |eth|
      assert_includes last_response.body, "#{eth}</li>"
    end
    recipe_data[:categories].split(/\r?\n/).each do |cat|
      assert_includes last_response.body, "#{cat}</li>"
    end
    recipe_data[:ingredients].split(/\r?\n/).each do |ing|
      assert_includes last_response.body, "#{ing}</li>"
    end
    recipe_data[:steps].split(/\r?\n/).each do |step|
      assert_includes last_response.body, "#{step}</li>"
    end
    recipe_data[:note].split(/\r?\n/).each do |note|
      assert_includes last_response.body, "#{note}</li>"
    end
    assert_includes last_response.body, "#{recipe_data[:name]} was successfully created."
  end

  def test_create_recipe_name_unique_error
    recipe_data = {
      name: 'Test Recipe 1',
      cook_time: '00:00',
    }

    must_be_signed_in(:post, "/recipe/create", recipe_data)
    sign_in(create_user)

    post '/recipe/create', recipe_data
    assert_equal 302, last_response.status
    post '/recipe/create', recipe_data
    assert_equal 422, last_response.status
    assert_includes last_response.body, 'Name must be unique'
  end

  def test_create_recipe_name_size_error
    recipe_data = {name: ''}
    must_be_signed_in(:post, "/recipe/create", recipe_data)
    sign_in(create_user)

    post '/recipe/create', recipe_data
    assert_equal 422, last_response.status
    assert_includes last_response.body, 'Name must be between 1 and 100 characters'
  end

  def test_create_recipe_minutes_out_of_range_cook_time_error
    recipe_data = {name: 'Test Recipe 1', hours: '1', minutes: '75'}

    must_be_signed_in(:post, "/recipe/create")
    sign_in(create_user)

    post '/recipe/create', recipe_data
    assert_equal 422, last_response.status
    assert_includes last_response.body, 'Cook time minutes must be between 0 and 59.'
  end

  def test_edit_recipe
    params = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1',
      hours: '1',
      minutes: '2',
      ethnicities: "e1\\r\\ne2",
      categories: "c1\\r\\nc2",
      ingredients: "i1\\r\\ni2",
      steps: "s1\\r\\ns2",
      note: "n1\\r\\nn2"
    }

    recipe_data = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1',
      cook_time: '1:02',
      note: "n1\\r\\nn2"
    }
    recipe = Recipe.create(recipe_data)

    must_be_signed_in(:post, "/recipe/#{recipe.id}", params)

    sign_in(create_user)
    post "/recipe/#{recipe.id}", params
    follow_redirect!

    assert_equal 200, last_response.status
    assert_includes last_response.body, params[:name]
    assert_includes last_response.body, params[:description]
    # assert_includes last_response.body, "#{recipe_data[:hours]} h #{recipe_data[:minutes]} m"
    params[:ethnicities].split(/\r?\n/).each do |eth|
      assert_includes last_response.body, "#{eth}</li>"
    end
    params[:categories].split(/\r?\n/).each do |cat|
      assert_includes last_response.body, "#{cat}</li>"
    end
    params[:ingredients].split(/\r?\n/).each do |ing|
      assert_includes last_response.body, "#{ing}</li>"
    end
    params[:steps].split(/\r?\n/).each do |step|
      assert_includes last_response.body, "#{step}</li>"
    end
    params[:note].split(/\r?\n/).each do |note|
      assert_includes last_response.body, "#{note}</li>"
    end
    assert_includes last_response.body, "#{params[:name]} was successfully updated."
  end

  def test_destroy_recipe
    recipe_data = {
      name: 'Test Recipe 1'
    }

    recipe = Recipe.create(recipe_data)
    recipe.save(validate: false)

    must_be_signed_in(:post, "/recipe/#{recipe.id}/destroy", {})

    sign_in(create_user)
    post "/recipe/#{recipe.id}/destroy", {}
    follow_redirect!

    assert_equal 200, last_response.status
    refute_includes last_response.body, "#{recipe_data[:name]}</h2>"
    assert_includes last_response.body, "#{recipe_data[:name]} was successfully deleted."
  end

  def test_load_recipe_when_id_not_found
    sign_in(create_user)
    get '/recipe/1'
    assert_equal 302, last_response.status
    assert_equal 'The specified recipe was not found.', session['flash'][:error]

    get '/recipe/1/edit'
    assert_equal 302, last_response.status
    assert_equal 'The specified recipe was not found.', session['flash'][:error]
  end
end
