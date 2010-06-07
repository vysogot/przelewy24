require File.dirname(__FILE__) + '/test_helper.rb' 

class P24Test < Test::Unit::TestCase 
  load_schema
 
  def test_p24 
    assert_kind_of P24, P24.new 
  end 
end
