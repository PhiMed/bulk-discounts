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
    bulk_discounts_for_this_invoice = (
                    BulkDiscount.all
                     .joins(merchant: {items: :invoice_items})
                     .where('invoice_id = ?', self.id)
                     .order(:percentage_discount)
                     .select('bulk_discounts.*'))

    item_discount_hash = {}

    invoice_items.each do |invoice_item|
      bulk_discounts_for_this_invoice.each do |bulk_discount|
        best_discount = []
        if bulk_discount.quantity_threshold <= invoice_item.quantity
          best_discount << bulk_discount
        end
        item_discount_hash[invoice_item.id] = {best_discount: best_discount[0].id,
                   discounted_item_revenue:
                   (invoice_item.quantity * invoice_item.unit_price * (best_discount[0].percentage_discount.to_f/100))}
      end
    end
    discounted_total = 0
    item_discount_hash.values.each do |item|
      discounted_total += item[:discounted_item_revenue]
    end
    discounted_total
  end
end
