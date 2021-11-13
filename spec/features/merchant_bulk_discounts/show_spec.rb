require 'rails_helper'
# FactoryBot.find_definitions

RSpec.describe 'merchant bulk discount index' do
  before(:each) do
    @merchant = create(:merchant)
  end

  it 'displays this merchants discounts' do

    discount_1 =  create(:bulk_discount, merchant: @merchant, percentage_discount: 10, quantity_threshold: 9)

    visit "/merchants/#{@merchant.id}/bulk_discounts/#{discount_1.id}"

    expect(page).to have_content("Percentage Discount: 10")
    expect(page).to have_content("Quantity Threshold: 9")
  end
end
