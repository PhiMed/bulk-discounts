require 'rails_helper'

RSpec.describe 'Merchant Items Index' do
  before :each do
    @merchant = Merchant.create!(name: "Angela's Shop")
    @item_1 = @merchant.items.create!(name: "Jade Rabbit", description: "25mmx25mm hand carved jade rabbit", unit_price: 2500)
    @item_2 = @merchant.items.create!(name: "Amazonite Rabbit", description: "25mmx25mm hand carved Amazonite rabbit", unit_price: 3500)
  end

  it 'lists the names of all the items' do

    visit "/merchants/#{@merchant.id}/items"

    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@item_2.name)

  end

  it 'links to items show page' do

    visit "/merchants/#{@merchant.id}/items"

    within('#item-0') do
      click_link
      expect(current_path).to eq("/merchants/#{@merchant.id}/items/#{@item_1.id}")
    end
  end
end