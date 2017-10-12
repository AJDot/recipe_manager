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
    @storage.add_categories_to_recipe(recipe_id, test_cat_name)

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
    @storage.add_categories_to_recipe(recipe_id, test_cat_name)

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
    @storage.add_ingredients_to_recipe(recipe_id, test_ing_info)

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
    @storage.add_ethnicities_to_recipe(recipe_id, test_eth)

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
    @storage.add_steps_to_recipe(recipe_id, test_step)

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
    @storage.add_notes_to_recipe(recipe_id, test_note)

    # Display recipe details
    get "/recipe/#{recipe_id}"

    assert_equal 200, last_response.status
    assert_includes last_response.body, recipe_data[:name]
    assert_includes last_response.body, recipe_data[:description]
    assert_includes last_response.body, test_note
  end
end
