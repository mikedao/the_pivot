class ItemOrder < ActiveRecord::Base
  belongs_to :item
  belongs_to :order

  # def quantity
  #   order.items.group_by {|}
  #   count
  # end
  #
  # # def line_item_cost
  # #
  # # end

end
