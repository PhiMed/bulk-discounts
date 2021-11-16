class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  delegate :merchant, to: :item
  delegate :customer, to: :invoice

  enum status: { "packaged" => 0,
                 "pending" => 1,
                 "shipped" => 2
               }

  scope :invoice_item_revenue, -> { sum("unit_price * quantity") }

  def self.invoice_item_price(invoice)
    find_by(invoice: invoice).unit_price
  end

  def self.invoice_item_quantity(invoice)
    find_by(invoice: invoice).quantity
  end

  def self.invoice_item_status(invoice)
    find_by(invoice: invoice).status
  end

  def self.invoice_item_bulk_discount_applied(invoice)
    merchant = (Item.find(self.find_by(invoice: invoice)
                    .item_id)
                    .merchant)
    if invoice.item_discount_hash(merchant).values.any?
      discount = invoice.item_discount_hash(merchant)
                        .values[0][:best_discount]
    else
      discount = nil
    end
    if discount != nil
      BulkDiscount.find(discount)
    else
      nil
    end
  end
end
