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

  def merchant_invoice_revenue(merchant)
    merchants_invoice_items(merchant).sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def merchants_invoice_items(merchant)
    invoice_items.joins(item: :merchant)
                 .where('merchant_id  = ?', merchant.id)
  end

  def bulk_discounts_for_this_invoice(merchant)
    BulkDiscount.all
                .joins(merchant: {items: :invoice_items})
                .where('invoice_id = ?', self.id)
                .where('merchants.id  = ?', merchant.id)
  end

  def item_discount_hash(merchant)
    bulk_discounts_for_this_invoice = bulk_discounts_for_this_invoice(merchant)
    merchants_invoice_items = merchants_invoice_items(merchant)
    item_discount_hash = {}
    merchants_invoice_items.each do |invoice_item|
      eligible_discounts = []
      bulk_discounts_for_this_invoice.each do |bulk_discount|
        if bulk_discount.quantity_threshold <= invoice_item.quantity
          eligible_discounts << bulk_discount
        end
        if eligible_discounts[0] != nil
          best_discount = eligible_discounts.sort_by {|discount| discount.percentage_discount}.reverse[0]
          item_discount_hash[invoice_item.id] = {
            best_discount: best_discount.id, discounted_item_revenue:
              (invoice_item.quantity * invoice_item.unit_price *
              (100 - (best_discount.percentage_discount.to_f))/100)}
        else
          item_discount_hash[invoice_item.id] = {
            best_discount: nil, discounted_item_revenue:
             (invoice_item.quantity * invoice_item.unit_price)}
        end
      end
    end
    item_discount_hash
  end

  def discounted_merchant_invoice_revenue(merchant)
    hash = item_discount_hash(merchant)
    if hash.empty?
      discounted_total = merchant_invoice_revenue(merchant)
    else
      discounted_total = 0
      hash.values.each do |item|
        discounted_total += item[:discounted_item_revenue]
      end
    end
    discounted_total
  end

  def discounted_invoice_revenue
    merchants = Merchant.where(:id => items.pluck(:merchant_id).uniq)
    discounted_total = 0
    merchants.each do |m|
      discounted_total += discounted_merchant_invoice_revenue(m)
    end
    discounted_total
  end
end
