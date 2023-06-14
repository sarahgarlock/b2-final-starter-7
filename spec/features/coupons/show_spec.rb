require 'rails_helper'

RSpec.describe 'Merchant Coupons Show Page' do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Body Care")

    @customer1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")

    @coupon1 = @merchant1.coupons.create!(name: "10% off", code: "10%OFF", value: 10, amount_type: 0)
    @coupon2 = @merchant1.coupons.create!(name: "20% off", code: "20%OFF", value: 20, amount_type: 0)
    @coupon3 = @merchant1.coupons.create!(name: "$30 off", code: "$30OFF", value: 30, amount_type: 1)
    @coupon4 = @merchant1.coupons.create!(name: "40% off", code: "40%OFF", value: 40, amount_type: 0)
    @coupon5 = @merchant1.coupons.create!(name: "50% off", code: "50%OFF", value: 50, amount_type: 0)
    @coupon6 = @merchant1.coupons.create!(name: "60% off", code: "60%OFF", value: 60, amount_type: 0)
    @coupon7 = @merchant1.coupons.create!(name: "70% off", code: "70%OFF", value: 70, amount_type: 0, status: 0)
    @coupon8 = @merchant2.coupons.create!(name: "$40 off", code: "$40OFF", value: 40, amount_type: 1, status: 1)

    @invoice1 = Invoice.create!(customer_id: @customer1.id, status: 2, coupon_id: @coupon1.id)
    @invoice2 = Invoice.create!(customer_id: @customer1.id, status: 2, coupon_id: @coupon2.id)
    @invoice3 = Invoice.create!(customer_id: @customer1.id, status: 2, coupon_id: @coupon3.id)
    @invoice4 = Invoice.create!(customer_id: @customer2.id, status: 2, coupon_id: @coupon1.id)
    @invoice5 = Invoice.create!(customer_id: @customer2.id, status: 2, coupon_id: @coupon2.id)
    @invoice6 = Invoice.create!(customer_id: @customer2.id, status: 2, coupon_id: @coupon2.id)
    @invoice7 = Invoice.create!(customer_id: @customer2.id, status: 2, coupon_id: @coupon7.id)
    @invoice8 = Invoice.create!(customer_id: @customer2.id, status: 2, coupon_id: @coupon1.id)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @invoice_item1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice1.id, quantity: 1, unit_price: 10, status: 2)
    @invoice_item2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice2.id, quantity: 1, unit_price: 8, status: 2)
    @invoice_item3 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice3.id, quantity: 1, unit_price: 5, status: 2)
    @invoice_item4 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice4.id, quantity: 1, unit_price: 1, status: 2)
    @invoice_item5 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice5.id, quantity: 1, unit_price: 1, status: 2)
    @invoice_item6 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice7.id, quantity: 1, unit_price: 1, status: 2)
    @invoice_item7 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice8.id, quantity: 1, unit_price: 1, status: 2)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice2.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice3.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice4.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice5.id)
    @transaction6 = Transaction.create!(credit_card_number: 102938, result: 0, invoice_id: @invoice6.id)
    @transaction7 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice7.id)

  end
  
  describe 'As a merchant, when I visit my coupon show page' do
    it 'displays all of my coupon attributes' do
      visit "/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}"
      expect(page).to have_content("Name: #{@coupon1.name}")
      expect(page).to have_content("Code: #{@coupon1.code}")
      expect(page).to have_content("Discount Value: #{@coupon1.value}%")
      expect(page).to have_content("Status: #{@coupon1.status}")
      expect(page).to have_content("Times Used: 2")
      
      visit "/merchants/#{@merchant1.id}/coupons/#{@coupon3.id}"
      expect(page).to have_content("Name: #{@coupon3.name}")
      expect(page).to have_content("Code: #{@coupon3.code}")
      expect(page).to have_content("Discount Value: $#{@coupon3.value}")
      expect(page).to have_content("Status: #{@coupon3.status}")
      expect(page).to have_content("Times Used: 1")
    end

    it 'displays times used' do
      visit "/merchants/#{@merchant1.id}/coupons/#{@coupon2.id}"
    
      expect(page).to have_content("Times Used: 2")
    end

    it 'has a button to deactivate the coupon' do
      visit "/merchants/#{@merchant1.id}/coupons/#{@coupon7.id}"
      expect(@coupon7.status).to eq("active")
      expect(page).to have_button("Deactivate Coupon")

      click_button "Deactivate Coupon"

      expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons/#{@coupon7.id}")
      expect(page).to have_content("Status: inactive")
    end

    it 'has a button to activate the coupon' do
      visit "/merchants/#{@merchant2.id}/coupons/#{@coupon8.id}"

      expect(@coupon8.status).to eq("inactive")
      expect(page).to have_button("Activate Coupon")

      click_button "Activate Coupon"

      expect(current_path).to eq("/merchants/#{@merchant2.id}/coupons/#{@coupon8.id}")
      expect(page).to have_content("Status: active")
    end
  end
end