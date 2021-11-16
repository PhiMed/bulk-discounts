require 'rails_helper'
# FactoryBot.find_definitions

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it {should belong_to :customer}
    it {should have_many :transactions}
    it {should have_many :invoice_items}
    it {should have_many(:items).through(:invoice_items)}
  end

  describe 'class methods' do
    before :each do
      @invoice1 = create(:invoice, created_at: "2012-03-25 09:54:09 UTC")
      @invoice2 = create(:invoice, created_at: "2012-03-26 06:54:10 UTC")
      @invoice3 = create(:invoice, created_at: "2012-03-26 06:54:10 UTC")
      @completed_invoice = create(:invoice, created_at: "2011-03-25 09:54:09 UTC")
      @incomplete_invoice_1 = create(:invoice, created_at: "2011-03-25 09:54:09 UTC")
      @incomplete_invoice_2 = create(:invoice, created_at: "2011-03-25 09:54:09 UTC")
    end

    describe '#highest_date' do
      it 'should return the date with the highest number of invoices' do
        expect(Invoice.highest_date).to eq(@invoice2.created_at)
      end
    end

    describe '#incomplete_invoices' do
      it 'returns all incomplete_invoices' do
        invoice_item1 = create(:invoice_item, invoice: @completed_invoice, status: 2)
        invoice_item2 = create(:invoice_item, invoice: @incomplete_invoice_1, status: 0)
        invoice_item2 = create(:invoice_item, invoice: @incomplete_invoice_2, status: 1)
        expect(Invoice.incomplete_invoices).to eq([@incomplete_invoice_1, @incomplete_invoice_2])
      end
    end
  end

  describe 'instance methods' do
    describe '.invoice_revenue' do
      it 'returns the total invoice revenue(admin)' do
        invoice = create(:invoice)
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_1)
        item_3 = create(:item, merchant: merchant_2)
        item_4 = create(:item, merchant: merchant_2)
        invoice_item_1 = create(:invoice_item, invoice: invoice, item: item_1, unit_price: 10, quantity: 1)
        invoice_item_2 = create(:invoice_item, invoice: invoice, item: item_2, unit_price: 10, quantity: 1)
        invoice_item_3 = create(:invoice_item, invoice: invoice, item: item_3, unit_price: 10, quantity: 1)
        invoice_item_4 = create(:invoice_item, invoice: invoice, item: item_4, unit_price: 10, quantity: 1)
        expect(invoice.invoice_revenue).to eq 40
      end
    end
  end

  describe '.discounted_invoice_revenue' do
    it 'returns the total discounted revenue(admin)' do
      invoice = create(:invoice)
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_1)
      item_3 = create(:item, merchant: merchant_2)
      item_4 = create(:item, merchant: merchant_2)
      invoice_item_1 = create(:invoice_item, invoice: invoice, item: item_1, unit_price: 10, quantity: 5)
      invoice_item_2 = create(:invoice_item, invoice: invoice, item: item_2, unit_price: 10, quantity: 10)
      invoice_item_3 = create(:invoice_item, invoice: invoice, item: item_3, unit_price: 10, quantity: 2)
      invoice_item_4 = create(:invoice_item, invoice: invoice, item: item_4, unit_price: 10, quantity: 1)
      bulk_discount_1 = create(:bulk_discount,
                              merchant: merchant_1,
                              percentage_discount: 50,
                              quantity_threshold: 6)
      bulk_discount_2 = create(:bulk_discount,
                              merchant: merchant_2,
                              percentage_discount: 10,
                              quantity_threshold: 2)

      expect(invoice.discounted_invoice_revenue).to eq 128
    end

    describe '.merchant_invoice_revenue' do
      it 'returns the total invoice revenue for a merchant' do
      invoice = create(:invoice)
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_1)
      item_3 = create(:item, merchant: merchant_2)
      item_4 = create(:item, merchant: merchant_2)
      invoice_item_1 = create(:invoice_item, invoice: invoice, item: item_1, unit_price: 10, quantity: 1)
      invoice_item_2 = create(:invoice_item, invoice: invoice, item: item_2, unit_price: 10, quantity: 1)
      invoice_item_3 = create(:invoice_item, invoice: invoice, item: item_3, unit_price: 100, quantity: 1)
      invoice_item_4 = create(:invoice_item, invoice: invoice, item: item_4, unit_price: 100, quantity: 1)
      expect(invoice.merchant_invoice_revenue(merchant_1)).to eq 20
      expect(invoice.merchant_invoice_revenue(merchant_2)).to eq 200
      end
    end
  end

  describe '.discounted_merchant_invoice_revenue' do
    it 'returns the discounted invoice revenue for a merchant' do
      invoice = create(:invoice)
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant)
      invoice_item1 = create(:invoice_item, invoice: invoice, item: item_1, unit_price: 1, quantity: 10)
      bulk_discount_1 = create(:bulk_discount,
                              merchant: merchant,
                              percentage_discount: 50,
                              quantity_threshold: 9)

      expect(invoice.discounted_merchant_invoice_revenue(merchant)).to eq 5
    end

    it 'example1' do
      invoice = create(:invoice)
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant)
      item_2 = create(:item, merchant: merchant)
      invoice_item1 = create(:invoice_item, invoice: invoice, item: item_1, unit_price: 10, quantity: 5)
      invoice_item2 = create(:invoice_item, invoice: invoice, item: item_2, unit_price: 10, quantity: 5)
      bulk_discount_1 = create(:bulk_discount,
                              merchant: merchant,
                              percentage_discount: 20,
                              quantity_threshold: 10)
      expect(invoice.discounted_merchant_invoice_revenue(merchant)).to eq 100
    end

    it 'example2' do
      invoice = create(:invoice)
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant)
      item_2 = create(:item, merchant: merchant)
      invoice_item1 = create(:invoice_item, invoice: invoice, item: item_1, unit_price: 10, quantity: 10)
      invoice_item2 = create(:invoice_item, invoice: invoice, item: item_2, unit_price: 10, quantity: 5)
      bulk_discount_1 = create(:bulk_discount,
                              merchant: merchant,
                              percentage_discount: 20,
                              quantity_threshold: 10)
      expect(invoice.discounted_merchant_invoice_revenue(merchant)).to eq 130
    end

    it 'example3' do
      invoice = create(:invoice)
      merchant = create(:merchant)
      item_a = create(:item, merchant: merchant)
      item_b = create(:item, merchant: merchant)
      invoice_item_a = create(:invoice_item, invoice: invoice, item: item_a, unit_price: 10, quantity: 12)
      invoice_item_b = create(:invoice_item, invoice: invoice, item: item_b, unit_price: 10, quantity: 15)
      bulk_discount_a = create(:bulk_discount,
                              merchant: merchant,
                              percentage_discount: 20,
                              quantity_threshold: 10)
      bulk_discount_b = create(:bulk_discount,
                              merchant: merchant,
                              percentage_discount: 30,
                              quantity_threshold: 15)
      expect(invoice.discounted_merchant_invoice_revenue(merchant)).to eq 201
    end

    it 'example4' do
      invoice = create(:invoice)
      merchant = create(:merchant)
      item_a = create(:item, merchant: merchant)
      item_b = create(:item, merchant: merchant)
      invoice_item_a = create(:invoice_item, invoice: invoice, item: item_a, unit_price: 10, quantity: 12)
      invoice_item_b = create(:invoice_item, invoice: invoice, item: item_b, unit_price: 10, quantity: 15)
      bulk_discount_a = create(:bulk_discount,
                              merchant: merchant,
                              percentage_discount: 20,
                              quantity_threshold: 10)
      bulk_discount_b = create(:bulk_discount,
                              merchant: merchant,
                              percentage_discount: 15,
                              quantity_threshold: 15)
      expect(invoice.discounted_merchant_invoice_revenue(merchant)).to eq 216
    end

    it 'example5' do
      invoice = create(:invoice)
      other_invoice = create(:invoice)
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      item_a1 = create(:item, merchant: merchant_1)
      item_a2 = create(:item, merchant: merchant_1)
      item_b = create(:item, merchant: merchant_2)
      item_c = create(:item, merchant: merchant_1)
      invoice_item_a1 = create(:invoice_item, invoice: invoice, item: item_a1, unit_price: 10, quantity: 12)
      invoice_item_a2 = create(:invoice_item, invoice: invoice, item: item_a2, unit_price: 10, quantity: 15)
      invoice_item_b = create(:invoice_item, invoice: invoice, item: item_b, unit_price: 20000, quantity: 20000)
      invoice_item_c = create(:invoice_item, invoice: other_invoice, item: item_c, unit_price: 10000, quantity: 10000)
      bulk_discount_a = create(:bulk_discount,
                              merchant: merchant_1,
                              percentage_discount: 20,
                              quantity_threshold: 10)
      bulk_discount_b = create(:bulk_discount,
                              merchant: merchant_2,
                              percentage_discount: 30,
                              quantity_threshold: 15)
      expect(invoice.discounted_merchant_invoice_revenue(merchant_1)).to eq 201
    end
  end
end
