class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  has_many :merchants, through: :items
  enum status: { cancelled: 0,  "in progress"  => 1, completed: 2 }

  def self.incomplete_invoices
    joins(:invoice_items)
    .where.not('invoice_items.status = 2')
    .select('invoices.id, invoices.created_at')
    .order(:created_at)
    .distinct
  end

  def total_revenue
    invoice_items.sum('quantity * unit_price')
  end

  def discounted_invoice_items
    invoice_items
      .joins(item: { merchant: :discounts})
      .where('invoice_items.quantity >= discounts.quantity_threshold')
      .group(:id)
  end

  def discount_revenue
    discounted_invoice_items.sum do |invoice_item|
      invoice_item.revenue * invoice_item.percentage_highest_discount / 100
  end
end

  def discounted_total_revenue
    total_revenue - discount_revenue
  end
end
