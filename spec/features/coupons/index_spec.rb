require 'rails_helper'

RSpec.describe 'Merchant Coupons Index Page' do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @coupon1 = @merchant1.coupons.create!(name: "10% off", code: "10OFF", value: 10, status: 0)
    @coupon2 = @merchant1.coupons.create!(name: "20% off", code: "20OFF", value: 20, status: 0)
    @coupon3 = @merchant1.coupons.create!(name: "30% off", code: "30OFF", value: 30, status: 0)

    visit merchant_coupons_path(@merchant1)
  end
  describe 'As a merchant, when I visit my merchant dashboard page' do
    it 'display all of my coupon names including their amount off' do
      save_and_open_page
      expect(page).to have_content("Coupon Name: #{@coupon1.name}")
      expect(page).to have_content("Amount Off: #{@coupon1.value}")

      expect(page).to have_content("Coupon Name: #{@coupon2.name}")
      expect(page).to have_content("Amount Off: #{@coupon2.value}")

      expect(page).to have_content("Coupon Name: #{@coupon2.name}")
      expect(page).to have_content("Amount Off: #{@coupon2.value}")
    end
  end
end