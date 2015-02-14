class Cart
  def initialize(cart)
    @cart = cart
  end

  def projects
    output = {}
    @cart.each do |k,v|
      output[Project.find(k)] = v
    end
    output
  end
end
