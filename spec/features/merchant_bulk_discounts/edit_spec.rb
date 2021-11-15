require 'rails_helper'

RSpec.describe 'bulk_discount edit page' do
  before(:each) do
    @merchant = create(:merchant)
  end

  it 'can edit a bulk_discount' do
    discount_1 =  create(:bulk_discount, merchant: @merchant, percentage_discount: 50, quantity_threshold: 20)

    visit "/merchants/#{@merchant.id}/bulk_discounts/#{discount_1.id}/edit"
    fill_in 'percentage_discount', with: '19'
    fill_in 'quantity_threshold', with: '5'
    click_button

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{discount_1.id}")
    expect(page).to have_content("Information has been successfully updated")
  end
end
