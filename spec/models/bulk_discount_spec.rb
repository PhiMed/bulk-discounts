require 'rails_helper'
# FactoryBot.find_definitions

RSpec.describe BulkDiscount, type: :model do
  before :each do
    @merchant = create(:merchant)

    @discount =  create(:bulk_discount, merchant: @merchant)
    @discount =  create(:bulk_discount, merchant: @merchant)

    @item1 = create(:item, merchant: @merchant)
    @item2 = create(:item, merchant: @merchant)

    @invoice = create(:invoice)

    @transaction = create(:transaction, result: 'success', invoice: @invoice)

    @invitem1 = create(:invoice_item, quantity: 1, unit_price: 1, invoice: @invoice, item: @item1)
    @invitem2 = create(:invoice_item, quantity: 2, unit_price: 1, invoice: @invoice, item: @item2)

  end

  describe 'relationships' do
    it {should belong_to :merchant}
  end

  describe 'validations' do
    it {should validate_presence_of(:percentage_discount)}
    it {should validate_presence_of(:quantity_threshold)}
  end
  #
  # describe 'class methods' do
  #   describe '' do
  #     it '' do
  #       expect().to eq()
  #     end
  #   end
  # end
  #
  # describe 'instance methods' do
  #   describe '' do
  #     it '' do
  #
  #       expect().to eq()
  #     end
  #   end
  # end
end
