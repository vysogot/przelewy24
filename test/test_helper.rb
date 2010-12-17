ENV["RAILS_ENV"] = "test"

require 'test/unit'
require 'rubygems'
require 'yaml'
require 'active_record'
require 'sqlite3'

require File.dirname(__FILE__) + '/../app/models/cheese/widget.rb'

def load_schema
  config = YAML::load( IO.read( File.dirname(__FILE__) + '/database.yml') )

  # Manually initialize the database
  SQLite3::Database.new(File.dirname(__FILE__) + '/' + config['test']['database'])  
end
