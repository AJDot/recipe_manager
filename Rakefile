require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require 'rake/testtask'

namespace :db do
  desc "migrate your database"
  namespace :migrate do
    task :v2 do
      require_relative './bin/migrate_from_v1'
      migration = RecipeManager::MigrationV2.new
      migration.run
    end
  end
end

Rake::TestTask.new do |t|
  require 'dotenv/load'
  t.name = :test
  t.pattern = "test/**/*_test.rb"
  t.warning = true
end