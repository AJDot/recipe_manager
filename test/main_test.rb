ENV["RACK_ENV"] = "test"

require 'fileutils'
require 'minitest/autorun'
require 'minitest/reporters'
require 'rack/test'
Minitest::Reporters.use!

require_relative '../main.rb'

class RecipeManagerTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    # FileUtils.mkdir_p data_path

    # function will execute queries constructed as the result of a query
    # add this function if you see errors about execute not working
    # CREATE OR REPLACE FUNCTION execute(text) RETURNS VOID AS $BODY$BEGIN execute $1; END;$BODY$ LANGUAGE plpgsql;
    # Example
    # SELECT execute('TRUNCATE ' || tablename || ' CASCADE;') FROM pg_tables WHERE schemaname = 'public' AND tablename IN ('recipes', 'categories', 'ethnicities');

    @storage = DatabasePersistence.new
  end

  def teardown
    # FileUtils.remove_dir data_path

    delete_all_db_data
  end

  def delete_all_db_data
    sql_clean = <<~SQL
      SELECT execute('TRUNCATE ' || tablename || ' CASCADE;')
        FROM pg_tables
       WHERE schemaname = 'public'
         AND tablename IN ('recipes', 'categories', 'ethnicities');
    SQL
    @storage.query(sql_clean)
  end

  def test_view_recipe_cards
    recipe_data = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1'
    }
    @storage.create_recipe(recipe_data)
    recipe_id = @storage.find_recipe_id(recipe_data[:name])

    test_cat_name = 'Category 1'
    @storage.add_recipe_categories(recipe_id, test_cat_name)

    get '/'

    # Display recipe card
    assert_equal 200, last_response.status
    assert_includes last_response.body, recipe_data[:name]
    assert_includes last_response.body, recipe_data[:description]
    assert_includes last_response.body, test_cat_name
    assert_includes last_response.body, 'View Recipe'
  end

  def test_view_recipe_details
    recipe_data = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1'
    }
    @storage.create_recipe(recipe_data)
    recipe_id = @storage.find_recipe_id(recipe_data[:name])

    test_cat_name = 'Category 1'
    @storage.add_recipe_categories(recipe_id, test_cat_name)

    # Display recipe details
    get "/recipe/#{recipe_id}"

    assert_equal 200, last_response.status
    assert_includes last_response.body, recipe_data[:name]
    assert_includes last_response.body, recipe_data[:description]
    assert_includes last_response.body, test_cat_name
  end

  def test_view_recipe_detail_ingredients
    recipe_data = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1'
    }
    @storage.create_recipe(recipe_data)
    recipe_id = @storage.find_recipe_id(recipe_data[:name])

    test_ing_info = '1 cup Ingredient 1'
    @storage.add_recipe_ingredients(recipe_id, test_ing_info)

    # Display recipe details
    get "/recipe/#{recipe_id}"

    assert_equal 200, last_response.status
    assert_includes last_response.body, recipe_data[:name]
    assert_includes last_response.body, recipe_data[:description]
    assert_includes last_response.body, test_ing_info
  end

  def test_view_recipe_detail_ethnicities
    recipe_data = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1'
    }
    @storage.create_recipe(recipe_data)
    recipe_id = @storage.find_recipe_id(recipe_data[:name])

    test_eth = 'Ethnicity 1'
    @storage.add_recipe_ethnicities(recipe_id, test_eth)

    # Display recipe details
    get "/recipe/#{recipe_id}"

    assert_equal 200, last_response.status
    assert_includes last_response.body, recipe_data[:name]
    assert_includes last_response.body, recipe_data[:description]
    assert_includes last_response.body, test_eth
  end

  def test_view_recipe_detail_steps
    recipe_data = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1'
    }
    @storage.create_recipe(recipe_data)
    recipe_id = @storage.find_recipe_id(recipe_data[:name])

    test_step = 'Step 1'
    @storage.add_recipe_steps(recipe_id, test_step)

    # Display recipe details
    get "/recipe/#{recipe_id}"

    assert_equal 200, last_response.status
    assert_includes last_response.body, recipe_data[:name]
    assert_includes last_response.body, recipe_data[:description]
    assert_includes last_response.body, test_step
  end

  def test_view_recipe_detail_notes
    recipe_data = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1'
    }
    @storage.create_recipe(recipe_data)
    recipe_id = @storage.find_recipe_id(recipe_data[:name])

    test_note = 'Note 1'
    @storage.add_recipe_notes(recipe_id, test_note)

    # Display recipe details
    get "/recipe/#{recipe_id}"

    assert_equal 200, last_response.status
    assert_includes last_response.body, recipe_data[:name]
    assert_includes last_response.body, recipe_data[:description]
    assert_includes last_response.body, test_note
  end

  def test_create_recipe
    recipe_data = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1',
      ethnicities: "e1\\r\\ne2",
      categories: "c1\\r\\nc2",
      ingredients: "i1\\r\\ni2",
      steps: "s1\\r\\ns2",
      notes: "n1\\r\\nn2",
      current_image: 'test_image.jpg'
    }

    post "/recipe/create", recipe_data
    assert_equal 302, last_response.status

    get last_response["Location"]
    assert_equal 200, last_response.status
    assert_includes last_response.body, recipe_data[:name]
    assert_includes last_response.body, recipe_data[:description]
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
    recipe_data[:notes].split(/\r?\n/).each do |note|
      assert_includes last_response.body, "#{note}</li>"
    end
    assert_includes last_response.body, recipe_data[:current_image]
  end

  def test_create_recipe_name_unique_error
    recipe_data = { name: 'Test Recipe 1' }

    post '/recipe/create', recipe_data
    assert_equal 302, last_response.status
    post '/recipe/create', recipe_data
    assert_equal 422, last_response.status
    assert_includes last_response.body, 'Recipe name must be unique.'
  end

  def test_create_recipe_name_size_error
    recipe_data = { name: '' }

    post '/recipe/create', recipe_data
    assert_equal 422, last_response.status
    assert_includes last_response.body, 'Recipe name must be between 1 and 100 characters.'
  end

  def test_edit_recipe
    recipe_data = {
      name: 'Test Recipe 1',
      description: 'Test recipe description 1',
      ethnicities: "e1\\r\\ne2",
      categories: "c1\\r\\nc2",
      ingredients: "i1\\r\\ni2",
      steps: "s1\\r\\ns2",
      notes: "n1\\r\\nn2"
    }

    @storage.create_recipe(recipe_data)
    recipe_id = @storage.find_recipe_id(recipe_data[:name])

    post "/recipe/#{recipe_id}", recipe_data
    assert_equal 302, last_response.status

    get last_response["Location"]
    assert_equal 200, last_response.status
    assert_includes last_response.body, recipe_data[:name]
    assert_includes last_response.body, recipe_data[:description]
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
    recipe_data[:notes].split(/\r?\n/).each do |note|
      assert_includes last_response.body, "#{note}</li>"
    end
  end

  def test_destroy_recipe
    recipe_data = {
      name: 'Test Recipe 1'
    }

    @storage.create_recipe(recipe_data)
    recipe_id = @storage.find_recipe_id(recipe_data[:name])

    post "/recipe/#{recipe_id}/destroy", recipe_data
    assert_equal 302, last_response.status

    get last_response["Location"]
    assert_equal 200, last_response.status
    refute_includes last_response.body, recipe_data[:name]
  end
end
