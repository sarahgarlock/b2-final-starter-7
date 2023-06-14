class CouponsController < ApplicationController
  def index
    @coupons = Coupon.includes(:merchant)
    @merchant = Merchant.find(params[:merchant_id])
    @holidays_us = Holiday.new.fetch_upcoming_holidays(3)
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
    else 
      @coupon.save
      redirect_to merchant_coupons_path(@merchant)
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
      @merchant.check_invoice_status?
      @coupon.update(status: "inactive")
    elsif params[:activate] == "true"
      if @merchant.coupon_count?
        flash[:alert] = "Error: Too many active coupons"
      else
        @coupon.update(status: "active")
      end
    end
  
    redirect_to merchant_coupon_path(@merchant, @coupon)
  end

  
  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :value, :amount_type)
  end
end