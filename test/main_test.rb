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
    FileUtils.mkdir_p data_path
  end

  def teardown
    FileUtils.remove_dir data_path
  end

  def test_test
    get '/'
    assert_equal 200, last_response.status
  end
end
