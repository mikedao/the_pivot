class Cart < ActiveRecord::Base
  def inititalize(cart)
    @cart = cart
  end

  def items
    @cart.map do |k,v|
      Item.find(k)
    end
  end
end
