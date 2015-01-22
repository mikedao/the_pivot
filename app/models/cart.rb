class Cart
  def initialize(cart)
    @cart = cart
  end

  def items
    @cart.map do |k,v|
      Item.find(k)
    end
  end
end
