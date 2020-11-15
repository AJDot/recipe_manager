require 'yaml'
require 'sinatra/activerecord'

environment = ENV.fetch('RACK_ENV') { 'development' }
db_options = YAML.load(File.read(File.expand_path('database.yml', __dir__)))
ActiveRecord::Base.establish_connection(db_options[environment])
