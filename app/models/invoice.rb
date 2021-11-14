class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  enum status: { "cancelled" => 0,
                 "completed" => 1,
                 "in progress" => 2
               }
  scope :incomplete_invoices, -> { joins(:invoice_items)
                                  .where(invoice_items: {status: ['0','1']})
                                  .group(:id)
                                  .order(:created_at ) }

  scope :highest_date, -> { select("invoices.created_at")
                            .order(created_at: :desc)
                            .group(:created_at)
                            .order("invoices.count DESC")
                            .first
                            .created_at }

  def invoice_revenue
    invoice_items.invoice_item_revenue
  end

  def discounted_invoice_revenue
    bulk_discounts = BulkDiscount.all.joins(merchant: {items: :invoice_items}).where('invoice_id = ?', self.id).order(:percentage_discount)
    top_discount_rate = bulk_discounts.limit(1).pluck(:percentage_discount).first.to_f / 100
    threshold_of_top_discount = bulk_discounts.limit(1).pluck(:quantity_threshold)
    top_discount_eligible_invoice_items = invoice_items.where('quantity > ?', threshold_of_top_discount)
    top_discount = top_discount_eligible_invoice_items.invoice_item_revenue * top_discount_rate
    discounted_revenue = invoice_revenue - top_discount
    discounted_revenue
  end
end
