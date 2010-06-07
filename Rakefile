require 'rubygems'
require 'rubygems/package_task'

PKG_FILES = FileList[
  '[a-zA-Z]*',
  'generators/**/*'
]

spec = Gem::Specification.new do |s|
  s.name = "rails-przelewy24"
  s.version = "0.0.1"
  s.author = "Jakub Godawa, Łukasz Krystkowiak"
  s.email = "jakub.godawa@gmail.com"
  s.homepage = "http://github.com/vysogot/przelewy24"
  s.platform = Gem::Platform::RUBY
  s.summary = "Tool to deal with Przelewy24.pl payment service"
  s.description = "Gem that can generate files necesary to be able to use Przelewy24.pl as your payment service."
  s.files = PKG_FILES.to_a
  s.has_rdoc = false
  s.extra_rdoc_files = ["README"]
end

desc 'Turn this plugin into a gem.'
Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
