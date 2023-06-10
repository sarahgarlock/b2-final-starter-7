class CouponsController < ApplicationController
  def index
    @coupons = Coupon.includes(:merchant)
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = @merchant.coupons.build
  end

  def create
    @merchant = Merchant.find(params[:merchant_id]) 
    @coupon = @merchant.coupons.new(coupon_params)

    if @coupon.save
      redirect_to merchant_coupons_path(@merchant)
    else
      render :new
    end
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :value, :amount_type)
  end
end