desc 'Setup basic ruby files and folders'
task :initialize_project do
  folders = ['lib', 'public', 'public/images', 'public/javascripts',
             'public/stylesheets', 'test', 'views']
  files = ['Gemfile', 'main.rb', 'views/layout.erb',
           'test/main_test.rb', 'public/stylesheets/main.css']

  folders.each { |folder| sh "mkdir #{folder}" unless Dir.exist?(folder) }
  files.each { |file| sh "touch #{file}" unless File.file?(file) }
end
