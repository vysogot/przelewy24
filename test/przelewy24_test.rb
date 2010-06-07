require 'test_helper'

class Przelewy24Test < Test::Unit::TestCase
  load_schema

  class P24 < ActiveRecord::Base
  end

  def test_schema_has_loaded_correctly
    assert_equal [], P24.all
  end
end
