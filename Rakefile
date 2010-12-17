require 'rake/testtask'

Rake::TestTask.new do |test|
  test.pattern = 'test/**/*_test.rb'
  test.libs << 'test'
end


begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name = "przelewy24"
    gem.homepage = "http://github.com/rails3-przelewy24"
    gem.summary = "This is a Rails engine to play with Polish payment service Przelewy24.pl"
    gem.description = "Gem consist of a generator 'przelewy24'. Application that have products for sale finally sends the form to Przelewy24 service. All transaction security and verification is held by generated files and Przelewy24 side."
    gem.email = "jakub.godawa@gmail.com"
    gem.authors = ["Jakub Godawa"]
    gem.files = Dir["{lib}/**/*", "{app}/**/*", "{public}/**/*", "{config}/**/*"]
    gem.rubyforge_project = "rails-p24"
  end
  Jeweler::GemcutterTasks.new
rescue
  puts "Jeweler or dependency not available."
end
