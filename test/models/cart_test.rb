require 'test_helper'

class CartTest < ActiveSupport::TestCase
  test "it can be initialized" do
    assert Cart.new(["empty"])
  end
end
