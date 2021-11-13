require 'rails_helper'
# FactoryBot.find_definitions

RSpec.describe 'merchant bulk discount index' do
  before(:each) do
    @merchant = create(:merchant)
  end

  it 'displays this merchants discounts' do

    discount_1 =  create(:bulk_discount, merchant: @merchant)

    visit "/merchants/#{@merchant.id}/bulk_discounts/#{discount_1.id}"

    expect(page).to have_content("Percentage Discount: #{discount_1.percentage_discount}")
    expect(page).to have_content("Quantity Threshold: #{discount_1.quantity_threshold}")
  end

  it 'has a link to edit the discount' do
    discount_1 =  create(:bulk_discount, merchant: @merchant, percentage_discount: 10, quantity_threshold: 9)

    visit "/merchants/#{@merchant.id}/bulk_discounts/#{discount_1.id}"

    click_link("Edit this bulk discount")

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{discount_1.id}/edit")
  end

end
