class MerchantBulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
    @holidays = HolidayService.new
  end

  def show
    @merchant = Merchant.find(params[:id])
    @bulk_discount = BulkDiscount.find(params[:bulk_discount_id])
  end

  def new
    @merchant = Merchant.find(params[:id])
  end
end
