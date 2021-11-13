require 'rails_helper'
# FactoryBot.find_definitions

RSpec.describe 'merchant bulk discount index' do
  before(:each) do
    @merchant = create(:merchant)
  end

  it 'displays this merchants discounts' do

    discount_1 =  create(:bulk_discount, merchant: @merchant)
    discount_2 =  create(:bulk_discount, merchant: @merchant)
    other_merchant = create(:merchant)
    other_discount =  create(:bulk_discount, merchant: other_merchant)

    visit "/merchants/#{@merchant.id}/bulk_discounts"

    expect(page).to have_content("Percentage Discount: #{discount_1.percentage_discount}")
    expect(page).to have_content("Quantity Threshold: #{discount_1.quantity_threshold}")
    expect(page).to have_content("Percentage Discount: #{discount_1.percentage_discount}")
    expect(page).not_to have_content("Percentage Discount: #{other_discount.percentage_discount}")

    within("#discount-#{discount_1.id}") do
      has_link?("View discount")

      click_link("View discount")

      expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{discount_1.id}")
    end
  end

  it 'displays the upcoming holidays' do

    visit "/merchants/#{@merchant.id}/bulk_discounts"

    expect(page).to have_content("Upcoming Holidays")
    expect(page).to have_content("2021-11-25 Thanksgiving Day")
    expect(page).to have_content("2021-12-24 Christmas Day")
    expect(page).to have_content("2021-12-31 New Year's Day")
    expect(page).not_to have_content("2022-01-17 Martin Luther King, Jr. Day")
  end

  it 'has a link to make a new discount' do
    visit "/merchants/#{@merchant.id}/bulk_discounts"

    within("#new-discount") do
      has_link?("Create New Discount")

      click_link("Create New Discount")

      expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/new")
    end
  end

  it 'has a button to delete each discount' do
    discount_1 = create(:bulk_discount, merchant: @merchant)
    visit "/merchants/#{@merchant.id}/bulk_discounts"
    expect(page).to have_content("Percentage Discount: #{discount_1.percentage_discount}")

    within("#discount-#{discount_1.id}") do
      click_button("Delete this Bulk Discount")
    end

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
    expect(page).not_to have_content("Percentage Discount: #{discount_1.percentage_discount}")
  end
end
