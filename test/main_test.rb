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

    @storage = DatabasePersistence.new
  end

  def teardown
    # FileUtils.remove_dir data_path

    # Remove all data from database
    sql_clean = <<~SQL
      SELECT execute('TRUNCATE ' || tablename || ' CASCADE;')
        FROM pg_tables
       WHERE schemaname = 'public'
         AND tablename IN ('recipes', 'categories', 'ethnicities');
    SQL
    @storage.query(sql_clean)
  end

  def test_view_index
    sql_insert = <<~SQL
      INSERT INTO recipes (name, description) VALUES
      ('Test Recipe 1', 'Test recipe description 1')
    SQL
    @storage.query(sql_insert)

    get '/'

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'Test Recipe 1'
    assert_includes last_response.body, 'Test recipe description 1'
  end
end
