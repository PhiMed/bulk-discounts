require 'rails_helper'

RSpec.describe 'bulk_discount new page' do
  before(:each) do
    @merchant = create(:merchant)
  end

  it 'can create a new item' do
    visit "/merchants/#{@merchant.id}/bulk_discounts/new"

    fill_in 'percentage_discount', with: '19'
    fill_in 'quantity_threshold', with: '5'

    click_button

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
    expect(page).to have_content("Percentage Discount: 19")
    expect(page).to have_content("Quantity Threshold: 5")
  end

  it 'shows an error flash message when nothing is entered' do
    visit "/merchants/#{@merchant.id}/bulk_discounts/new"

    click_button

    expect(page).to have_content("Bulk Discount could not be created")
  end
end
