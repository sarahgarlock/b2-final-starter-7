class CouponsController < ApplicationController
  def index
    @coupons = Coupon.includes(:merchant)
    @merchant = Merchant.find(params[:merchant_id])
  end
end