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
    if Coupon.coupon_code_exists?(@coupon.code)
      flash[:alert] = "Coupon code has already been taken"
      redirect_to new_merchant_coupon_path(@merchant)
    elsif @coupon.save
      redirect_to merchant_coupons_path(@merchant)
    else
      render :new
    end
  end

  def show
    @merchant = Merchant.find(params[:merchant_id]) 
    @coupon = Coupon.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant]) 
    @coupon = Coupon.find(params[:id])
    if params[:deactivate] == "true"
      @coupon.update(status: "inactive")
    else
      @coupon.update(status: "active")
    end
    @coupon.save
    redirect_to "/merchants/#{@merchant.id}/coupons/#{@coupon.id}"
  end
  
  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :value, :amount_type)
  end
end