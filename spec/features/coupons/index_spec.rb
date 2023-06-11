require 'rails_helper'

RSpec.describe 'Merchant Coupons Index Page' do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @coupon1 = @merchant1.coupons.create!(name: "10% off", code: "10%OFF", value: 10, amount_type: 0)
    @coupon2 = @merchant1.coupons.create!(name: "20% off", code: "20%OFF", value: 20, amount_type: 0)
    @coupon3 = @merchant1.coupons.create!(name: "$30 off", code: "$30OFF", value: 30, amount_type: 1, status: 0)
    @coupon4 = @merchant1.coupons.create!(name: "40% off", code: "40%OFF", value: 40, amount_type: 0)
    @coupon5 = @merchant1.coupons.create!(name: "50% off", code: "50%OFF", value: 50, amount_type: 0)
    @coupon6 = @merchant1.coupons.create!(name: "60% off", code: "60%OFF", value: 60, amount_type: 0)
    @coupon7 = @merchant1.coupons.create!(name: "$70 off", code: "$70OFF", value: 70, amount_type: 1, status: 0)

    visit "/merchants/#{@merchant1.id}/coupons"
  end
  describe 'As a merchant, when I visit my coupons index page' do
    it 'display all of my coupon\'s name, amount off and link to that show page' do
      expect(page).to have_link("Coupon Name: #{@coupon1.name}")
      expect(page).to have_content("Amount Off: #{@coupon1.value}%")
      
      expect(page).to have_content("Coupon Name: #{@coupon2.name}")
      expect(page).to have_content("Amount Off: #{@coupon2.value}%")
      
      expect(page).to have_content("Coupon Name: #{@coupon3.name}")
      expect(page).to have_content("Amount Off: $#{@coupon3.value}")
  
      click_link("Coupon Name: #{@coupon1.name}")

      expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}")
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
    end

    it 'displays and error message if coupon code is not unique' do
      click_link "Create New Coupon"

      fill_in "Name", with: "50% off"
      fill_in "Code", with: "50%OFF"
      fill_in "Discount", with: 50
      select "Percent", from: "coupon_amount_type"

      click_button "Submit"
      expect(current_path).to eq(new_merchant_coupon_path(@merchant1))
      expect(page).to have_content("Coupon code has already been taken")
    end

    # it 'displays an error message if a merchant has over 5 active coupons' do
    #   save_and_open_page
    #   check "coupon_1_active"
    #   check "coupon_2_active"
    #   check "coupon_3_active"
    #   check "coupon_4_active"
    #   check "coupon_5_active"
    #   check "coupon_6_active"
    #   expect(page).to have_content("You cannot have more than 5 active coupons")
    #   expect(@merchant1.coupons.active.count).to eq(5)
    # end
  end

  it 'separates active and inactive coupons' do
    expect(page).to have_content("Active Coupons")
    expect(page).to have_content("Inactive Coupons")

    within "#active-coupons" do
      expect(page).to have_content("Coupon Name: #{@coupon3.name}")
      expect(page).to have_content("Coupon Name: #{@coupon7.name}")

      expect(page).to_not have_content("Coupon Name: #{@coupon1.name}")
      expect(page).to_not have_content("Coupon Name: #{@coupon2.name}")
    end

    within "#inactive-coupons" do
      expect(page).to have_content("#{@coupon1.name}")
      expect(page).to have_content("#{@coupon2.name}")
      expect(page).to have_content("#{@coupon4.name}")
      expect(page).to have_content("#{@coupon5.name}")
      expect(page).to have_content("#{@coupon6.name}")
      
      expect(page).to_not have_content("#{@coupon3.name}")
      expect(page).to_not have_content("#{@coupon7.name}")
    end
  end
end