class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, Order, id: user.id
    # if user.admin?
    #   can :, Cart
    # end
  end
end
