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

  def create
    bulk_discount = Merchant.find(params[:id]).bulk_discounts.new(bulk_discount_params)
    if params[:percentage_discount].length > 0 && bulk_discount.save
      redirect_to "/merchants/#{params[:id]}/bulk_discounts"
    else
      flash[:alert] = "Bulk Discount could not be created"
      redirect_to "/merchants/#{params[:id]}/bulk_discounts/new"
    end
  end

  private
    def bulk_discount_params
      params.permit(:percentage_discount, :quantity_threshold)
    end
end
