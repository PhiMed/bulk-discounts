require 'rails_helper'
# FactoryBot.find_definitions

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it {should have_many :items}
  end

  before(:each) do
    @merchant = create(:merchant)

    @customer1, @customer2, @customer3 = create_list(:customer, 3)
    @customer4, @customer5, @customer6 = create_list(:customer, 3)

    @invoice1 = create(:invoice, customer: @customer1)
    @invoice2 = create(:invoice, customer: @customer2)
    @invoice3 = create(:invoice, customer: @customer3)
    @invoice4 = create(:invoice, customer: @customer4)
    @invoice5 = create(:invoice, customer: @customer5)
    @invoice6 = create(:invoice, customer: @customer6)

    @item1 = create(:item, merchant: @merchant)
    @item2 = create(:item, merchant: @merchant)
    @item3 = create(:item, merchant: @merchant)
    @item4 = create(:item, merchant: @merchant)
    @item5 = create(:item, merchant: @merchant)
    @item6 = create(:item, merchant: @merchant)

    create(:invoice_item, invoice: @invoice1, status:'packaged', item: @item1, quantity: 1, unit_price: 5)
    create(:invoice_item, invoice: @invoice2, status:'packaged',item: @item2, quantity: 1, unit_price: 2)
    create(:invoice_item, invoice: @invoice3, status:'packaged',item: @item3, quantity: 1, unit_price: 4)
    create(:invoice_item, invoice: @invoice4, status:'pending', item: @item4, quantity: 1, unit_price: 6)
    create(:invoice_item, invoice: @invoice5, status:'pending',item: @item5, quantity: 1, unit_price: 1)
    create(:invoice_item, invoice: @invoice6, status:'shipped', item: @item6, quantity: 1, unit_price: 3)

    create(:transaction, result: 'success', invoice: @invoice1)
    create(:transaction, result: 'success', invoice: @invoice1)
    create(:transaction, result: 'success', invoice: @invoice2)
    create(:transaction, result: 'success', invoice: @invoice2)
    create(:transaction, result: 'success', invoice: @invoice3)
    create(:transaction, result: 'success', invoice: @invoice3)
    create(:transaction, result: 'success', invoice: @invoice4)
    create(:transaction, result: 'success', invoice: @invoice4)
    create(:transaction, result: 'success', invoice: @invoice5)
    create(:transaction, result: 'success', invoice: @invoice5)
  end

  describe '.enabled' do
    it 'returns a collection of enabled merchants' do
      merchant_2 = create(:merchant, status: 1)
      expect(Merchant.enabled).to eq([merchant_2])
    end
  end

  describe '.disabled' do
    it 'returns a collection of disabled items' do
      @merchant_2 = create(:merchant, status: 1)
      expect(Merchant.disabled).to eq([@merchant])
    end
  end

  describe '#top_customers' do
    it 'returns the top 5 customers for the given merchant' do
      expect(@merchant.top_customers).to eq([@customer1, @customer2, @customer3, @customer4, @customer5])
    end
  end

  describe '#shippable_items' do
    it 'returns the items that are ready to ship in order from oldest to newest' do

      expect(@merchant.shippable_items.length).to eq(3)
      expect(@merchant.shippable_items).to eq([@item1, @item2, @item3])
      expect(@merchant.shippable_items.first.created_at).to be < @merchant.shippable_items.last.created_at
      # above method adjusted per shippable items changes in merchant class
    end
  end

  describe '#invoices' do
    it "returns all invoices related to that merchant's items" do
      expect(@merchant.invoice_ids).to include(@invoice1.id, @invoice2.id, @invoice3.id)
    end
  end

  describe '.top_five' do
    it 'returns the top five merchants by revenue' do
      merchant1, merchant2, merchant3 = create_list(:merchant, 3)
      merchant4, merchant5, merchant6 = create_list(:merchant, 3)

      items1 = create_list(:item, 3, merchant: merchant1)
      items2 = create_list(:item, 3, merchant: merchant2)
      items3 = create_list(:item, 3, merchant: merchant3)
      items4 = create_list(:item, 3, merchant: merchant4)
      items5 = create_list(:item, 3, merchant: merchant5)
      items6 = create_list(:item, 3, merchant: merchant6)

      invoices1 = create_list(:invoice, 3, customer: @customer1)
      invoices2 = create_list(:invoice, 3, customer: @customer1)
      invoices3 = create_list(:invoice, 3, customer: @customer1)
      invoices4 = create_list(:invoice, 3, customer: @customer1)
      invoices5 = create_list(:invoice, 3, customer: @customer1)
      invoices6 = create_list(:invoice, 3, customer: @customer1)

      items1.zip(invoices1) do |item, invoice|
        create(:invoice_item, quantity: 1, unit_price: 300, item: item, invoice: invoice)
      end
      items2.zip(invoices2) do |item, invoice|
        create(:invoice_item, quantity: 1, unit_price: 200, item: item, invoice: invoice)
      end
      items3.zip(invoices3) do |item, invoice|
        create(:invoice_item, quantity: 1, unit_price: 500, item: item, invoice: invoice)
      end
      items4.zip(invoices4) do |item, invoice|
        create(:invoice_item, quantity: 1, unit_price: 600, item: item, invoice: invoice)
      end
      items5.zip(invoices5) do |item, invoice|
        create(:invoice_item, quantity: 1, unit_price: 100, item: item, invoice: invoice)
      end
      items6.zip(invoices6) do |item, invoice|
        create(:invoice_item, quantity: 1, unit_price: 400, item: item, invoice: invoice)
      end

      Invoice.all.each do |invoice|
        create(:transaction, result: 'success', invoice: invoice)
      end

      expect(Merchant.top_five).to eq([merchant4, merchant3, merchant6, merchant1, merchant2])
    end
  end

  describe '#best_day' do
    it 'returns the best day' do
      merchant = create(:merchant)
      items1 = create_list(:item, 2, merchant: merchant)
      item3 = create(:item, merchant: merchant)
      invoices_1 = create_list(:invoice, 2, customer: @customer1, created_at: "2012-03-25 09:54:09 UTC")
      items1.zip(invoices_1) do |item, invoice|
        create(:invoice_item, quantity: 1, unit_price: 300, item: item, invoice: invoice)
      end
      invoice_3 = create(:invoice, customer: @customer1, created_at: "2012-03-10 09:54:09 UTC")
      create(:invoice_item, quantity: 1, unit_price: 1000, item: item3, invoice: invoice_3)
      Invoice.all.each do |invoice|
        create(:transaction, result: 'success', invoice: invoice)
      end
      expect(merchant.best_day).to eq("2012-03-10 09:54:09 UTC")
    end
  end
end
