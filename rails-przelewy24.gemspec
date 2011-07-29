# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rails-przelewy24}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jakub Godawa"]
  s.date = %q{2010-12-18}
  s.description = %q{Gem consist of a generator 'przelewy24'. Application that have products for sale finally sends the form to Przelewy24 service. All transaction security and verification is held by generated files and Przelewy24 side. For Rails 2.x use version 0.0.2}
  s.email = %q{jakub.godawa@gmail.com}
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
    "lib/generators/przelewy24/USAGE",
    "lib/generators/przelewy24/przelewy24_generator.rb",
    "lib/generators/przelewy24/templates/controller.rb",
    "lib/generators/przelewy24/templates/helper.rb",
    "lib/generators/przelewy24/templates/migration.rb",
    "lib/generators/przelewy24/templates/model.rb",
    "lib/generators/przelewy24/templates/przelewy24.yml",
    "lib/generators/przelewy24/templates/views/_form.html.erb",
    "lib/generators/przelewy24/templates/views/confirm.html.erb",
    "lib/generators/przelewy24/templates/views/error.html.erb",
    "lib/generators/przelewy24/templates/views/index.html.erb",
    "lib/generators/przelewy24/templates/views/new.html.erb",
    "lib/generators/przelewy24/templates/views/ok.html.erb",
    "lib/generators/przelewy24/templates/views/show.html.erb"
  ]
  s.homepage = %q{http://github.com/vysogot/przelewy24}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rails-p24}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{This is a Rails engine to play with Polish payment service Przelewy24.pl}
  s.test_files = [
    "test/test_helper.rb",
    "test/unit/widget_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
