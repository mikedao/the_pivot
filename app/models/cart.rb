class Cart
  def initialize(cart)
    @cart = cart
  end

  def items
    output = {}
    @cart.each do |k,v|
      output[Item.find(k)] = v
    end
    output
  end
end
