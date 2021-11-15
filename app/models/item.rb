class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  enum status: { "Disabled" => 0, "Enabled" => 1}

  scope :enabled, -> { where(status: 1) }
  scope :disabled, -> { where(status: 0) }
  scope :top_five_items, -> { joins(invoices: :transactions)
                              .where(transactions: {result: "success"})
                              .group(:id)
                              .select("items.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS total_revenue")
                              .order("total_revenue" => :desc)
                              .limit(5) }
  scope :shippable_items, -> { joins(:invoices)
                                .select("items.*, invoice_items.invoice_id as invoice_id")
                                .select("invoices.created_at AS invoice_created_at")
                                .where(invoice_items: {status: '0'})
                                .order(:invoice_created_at) }



  def invoice_item(invoice)
    InvoiceItem.find_by(item_id: self.id, invoice_id: invoice.id)
  end

  def invoice_item_price(invoice)
    invoice_items.invoice_item_price(invoice)
  end

  def invoice_item_quantity(invoice)
    invoice_items.invoice_item_quantity(invoice)
  end

  def invoice_item_status(invoice)
    invoice_items.invoice_item_status(invoice)
  end

  def invoice_item_bulk_discount_applied(invoice)
    invoice_items.invoice_item_bulk_discount_applied(invoice)
  end
end
