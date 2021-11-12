class Merchant < ApplicationRecord
  has_many :items
  has_many :bulk_discounts
  has_many :invoice_items, through: :items
  enum status: { "Disabled" => 0, "Enabled" => 1}
  scope :enabled, -> { where(status: 1) }
  scope :disabled, -> { where(status: 0) }
  scope :top_five, -> { joins(items: [{invoices: :transactions}] )
                        .where(transactions: {result: "success"})
                        .group(:id)
                        .select("merchants.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS total_revenue")
                        .order("total_revenue" => :desc)
                        .first(5) }


  def top_customers
    Customer.top_customers(self)
  end

  def shippable_items
    items.shippable_items
  end

  def invoice_ids
    items.joins(:invoices).distinct.pluck(:invoice_id)
  end

  def best_day
    items.joins(:invoices)
         .group('invoices.created_at')
         .select('invoices.created_at AS invoice_created_at, SUM(invoice_items.unit_price * invoice_items.quantity) AS day_revenue')
         .order('day_revenue DESC')
         .order(invoice_created_at: :desc)
         .first
         .invoice_created_at
  end
end
