require 'rails_helper'

RSpec.describe 'Merchant Coupons Index Page' do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @coupon1 = @merchant1.coupons.create!(name: "10% off", code: "10OFF", value: 10, amount_type: 0)
    @coupon2 = @merchant1.coupons.create!(name: "20% off", code: "20OFF", value: 20, amount_type: 0)
    @coupon3 = @merchant1.coupons.create!(name: "30% off", code: "30OFF", value: 30, amount_type: 0)
    @coupon4 = @merchant1.coupons.create!(name: "40% off", code: "40OFF", value: 40, amount_type: 0)
    @coupon5 = @merchant1.coupons.create!(name: "50% off", code: "50OFF", value: 50, amount_type: 0)
    @coupon6 = @merchant1.coupons.create!(name: "60% off", code: "60OFF", value: 60, amount_type: 0)

    visit merchant_coupons_path(@merchant1)
  end
  describe 'As a merchant, when I visit my merchant index page' do
    it 'display all of my coupon names including their amount off' do
      expect(page).to have_content("Coupon Name: #{@coupon1.name}")
      expect(page).to have_content("Amount Off: #{@coupon1.value}")

      expect(page).to have_content("Coupon Name: #{@coupon2.name}")
      expect(page).to have_content("Amount Off: #{@coupon2.value}")

      expect(page).to have_content("Coupon Name: #{@coupon3.name}")
      expect(page).to have_content("Amount Off: #{@coupon3.value}")
    end

    it 'has a link to create a new coupon and can create new coupons' do
      expect(page).to have_link("Create New Coupon")

      click_link "Create New Coupon"

      expect(current_path).to eq(new_merchant_coupon_path(@merchant1))
      expect(page).to have_field("Name")
      expect(page).to have_field("Code")
      expect(page).to have_field("Discount")
      expect(page).to have_field("Percent or Dollar")
      
      fill_in "Name", with: "70% off"
      fill_in "Code", with: "70OFF"
      fill_in "Discount", with: 70
      select "Percent", from: "coupon_amount_type"

      click_button "Submit" 

      expect(current_path).to eq(merchant_coupons_path(@merchant1))
      expect(page).to have_content("70% off")
      save_and_open_page
    end

    it 'displays only unique coupon codes' do
      click_link "Create New Coupon"

      fill_in "Name", with: "50% off"
      fill_in "Code", with: "50OFF"
      fill_in "Discount", with: 50
      select "Percent", from: "coupon_amount_type"

      click_button "Submit"
      expect(current_path).to eq(new_merchant_coupon_path(@merchant1))
      expect(page).to have_content("Coupon code has already been taken")
    end

  end
end
# As a merchant
# When I visit my coupon index page 
# I see a link to create a new coupon.
# When I click that link 
# I am taken to a new page where I see a form to add a new coupon.
# When I fill in that form with a name, unique code, an amount, and whether that amount is a percent or a dollar amount
# And click the Submit button
# I'm taken back to the coupon index page 
# And I can see my new coupon listed.


# * Sad Paths to consider: 
# 1. This Merchant already has 5 active coupons
# 2. Coupon code entered is NOT unique