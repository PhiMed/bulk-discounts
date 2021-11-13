require 'rails_helper'
# FactoryBot.find_definitions

RSpec.describe 'merchant bulk discount index' do
  before(:each) do
    @merchant = create(:merchant)
  end

  it 'displays this merchants discounts' do
    @discount_1 =  create(:bulk_discount, merchant: @merchant, percentage_discount: 10, quantity_threshold: 9)
    @discount_2 =  create(:bulk_discount, merchant: @merchant, percentage_discount: 20, quantity_threshold: 5)
    @other_merchant = create(:merchant)
    @other_discount =  create(:bulk_discount, merchant: @other_merchant, percentage_discount: 99, quantity_threshold: 2)

    visit "/merchants/#{@merchant.id}/bulk_discounts"

    expect(page).to have_content("Percentage Discount: 10")
    expect(page).to have_content("Quantity Threshold: 9")
    expect(page).to have_content("Percentage Discount: 20")
    expect(page).not_to have_content("Percentage Discount: 99")

    within("#discount-#{@discount_1.id}") do
      has_link?("View discount")

      click_link("View discount")

      expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}")
    end
  end

  it 'displays the upcoming holidays' do
    @discount_1 =  create(:bulk_discount, merchant: @merchant, percentage_discount: 10, quantity_threshold: 9)
    @discount_2 =  create(:bulk_discount, merchant: @merchant, percentage_discount: 20, quantity_threshold: 5)

    visit "/merchants/#{@merchant.id}/bulk_discounts"

    expect(page).to have_content("Upcoming Holidays")
    expect(page).to have_content("2021-11-25 Thanksgiving Day")
    expect(page).to have_content("2021-12-24 Christmas Day")
    expect(page).to have_content("2021-12-31 New Year's Day")
    expect(page).not_to have_content("2022-01-17 Martin Luther King, Jr. Day")
  end

  it 'can create a new discount' do
    @discount_1 =  create(:bulk_discount, merchant: @merchant, percentage_discount: 10, quantity_threshold: 9)
    @discount_2 =  create(:bulk_discount, merchant: @merchant, percentage_discount: 20, quantity_threshold: 5)

    visit "/merchants/#{@merchant.id}/bulk_discounts"

    expect(page).to have_link("Create New Discount")
  end
end
