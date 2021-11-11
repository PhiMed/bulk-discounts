require 'rails_helper'
# FactoryBot.find_definitions

RSpec.describe 'admin merchants index' do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:merchant)
    @merchant_4 = create(:merchant)
    @merchant_5 = create(:merchant)
  end

  it 'lists all merchants' do
    visit admin_merchants_path

     expect(page).to have_content(@merchant_1.name)
     expect(page).to have_content(@merchant_2.name)
     expect(page).to have_content(@merchant_3.name)
     expect(page).to have_content(@merchant_4.name)
     expect(page).to have_content(@merchant_5.name)
  end

  it 'links to a merchant show page' do
    visit admin_merchants_path

    click_link(@merchant_1.name)

    expect(current_path).to eq("/admin/merchants/#{@merchant_1.id}")
  end

  it 'has an interface to enable or disable merchants' do
    visit admin_merchants_path

    within("#disabled-merchants") do
      within("#merchant-#{@merchant_1.id}") do
        expect(page).not_to have_button("Disable")

        click_button("Enable")
      end
      expect(page).not_to have_content(@merchant_1.name)
    end

    within('#enabled-merchants') do
      within("#merchant-#{@merchant_1.id}") do
        expect(page).to have_button("Disable")

        click_button("Disable")

      end
      expect(page).not_to have_button("Disable")
      expect(page).not_to have_content(@merchant_1.name)
    end
  end

  it 'shows the top five merchants and their total revenue' do
    merchant1, merchant2, merchant3 = create_list(:merchant, 3)
    merchant4, merchant5, merchant6 = create_list(:merchant, 3)

    customer = create(:customer)

    items1 = create_list(:item, 3, merchant: merchant1)
    items2 = create_list(:item, 3, merchant: merchant2)
    items3 = create_list(:item, 3, merchant: merchant3)
    items4 = create_list(:item, 3, merchant: merchant4)
    items5 = create_list(:item, 3, merchant: merchant5)
    items6 = create_list(:item, 3, merchant: merchant6)

    invoices1 = create_list(:invoice, 3, customer: customer)
    invoices2 = create_list(:invoice, 3, customer: customer)
    invoices3 = create_list(:invoice, 3, customer: customer)
    invoices4 = create_list(:invoice, 3, customer: customer)
    invoices5 = create_list(:invoice, 3, customer: customer)
    invoices6 = create_list(:invoice, 3, customer: customer)

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

    top_merchants = Merchant.top_five

    visit admin_merchants_path

    within("#top_five_merchants") do
      expect(merchant4.name).to appear_before(merchant3.name)
      expect(merchant3.name).to appear_before(merchant6.name)
      expect(merchant6.name).to appear_before(merchant1.name)
      expect(merchant1.name).to appear_before(merchant2.name)
      expect(page).to_not have_content(merchant5.name)

      expect(page).to have_content("$#{top_merchants[0].total_revenue/100.0}0")
      expect(page).to have_content("$#{top_merchants[1].total_revenue/100.0}0")
      expect(page).to have_content("$#{top_merchants[2].total_revenue/100.0}0")
      expect(page).to have_content("$#{top_merchants[3].total_revenue/100.0}0")
      expect(page).to have_content("$#{top_merchants[4].total_revenue/100.0}0")
    end
  end

  it 'shows the top five merchants best day' do
    customer = create(:customer)
    merchant = create(:merchant)
    items1 = create_list(:item, 2, merchant: merchant)
    item3 = create(:item, merchant: merchant)
    invoices_1 = create_list(:invoice, 2, customer: customer, created_at: "2012-03-25 09:54:09 UTC")
    items1.zip(invoices_1) do |item, invoice|
      create(:invoice_item, quantity: 1, unit_price: 300, item: item, invoice: invoice)
    end
    invoice_3 = create(:invoice, customer: customer, created_at: "2012-03-10 09:54:09 UTC")
    create(:invoice_item, quantity: 1, unit_price: 1000, item: item3, invoice: invoice_3)
    invoice_4 = create(:invoice, customer: customer, created_at: "2012-03-11 09:54:09 UTC")
    create(:invoice_item, quantity: 1, unit_price: 1000, item: item3, invoice: invoice_4)
    Invoice.all.each do |invoice|
      create(:transaction, result: 'success', invoice: invoice)
    end

    visit admin_merchants_path
    within("#top_five_merchants") do
      expect(page).to have_content("Top selling date for this merchant was: Sunday, March 11, 2012")
    end
  end
end
