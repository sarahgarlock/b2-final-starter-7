require 'rails_helper'

RSpec.describe 'Merchant Coupons Index Page' do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @coupon1 = @merchant1.coupons.create!(name: "10% off", code: "10OFF", value: 10, amount_type: 0, status: 0)
    @coupon2 = @merchant1.coupons.create!(name: "20% off", code: "20OFF", value: 20, amount_type: 0, status: 0)
    @coupon3 = @merchant1.coupons.create!(name: "30% off", code: "30OFF", value: 30, amount_type: 0, status: 0)

    visit merchant_coupons_path(@merchant1)
  end
  describe 'As a merchant, when I visit my merchant index page' do
    it 'display all of my coupon names including their amount off' do
      expect(page).to have_content("Coupon Name: #{@coupon1.name}")
      expect(page).to have_content("Amount Off: #{@coupon1.value}")

      expect(page).to have_content("Coupon Name: #{@coupon2.name}")
      expect(page).to have_content("Amount Off: #{@coupon2.value}")

      expect(page).to have_content("Coupon Name: #{@coupon2.name}")
      expect(page).to have_content("Amount Off: #{@coupon2.value}")
    end

    it 'has a link to create a new coupon and can create new coupons' do
      expect(page).to have_link("Create New Coupon")

      click_link "Create New Coupon"

      expect(current_path).to eq(new_merchant_coupon_path(@merchant1))
      expect(page).to have_field("Name")
      expect(page).to have_field("Code")
      expect(page).to have_field("Discount")
      expect(page).to have_field("Percent or Dollar")
      save_and_open_page
      
      fill_in "Name", with: "50% off"
      fill_in "Code", with: "50OFF"
      fill_in "Discount", with: 50
      select "Percent", from: "coupon_amount_type"

      click_button "Submit" 

      expect(current_path).to eq(merchant_coupons_path(@merchant1))
      expect(page).to have_content("50% off")
    end
  end
end