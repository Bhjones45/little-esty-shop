class Discount < ApplicationRecord
  belongs_to :merchant

  def self.highest_possible_discount(quantity)
    where('quantity_threshold <= ?', quantity)
    .order(percentage_discount: :desc)
    .first
  end
end
