class MerchantsController < ApplicationController
  def index
    merchant = Merchant.where(id: params[:id])
    if merchant.any?
      redirect_to "/merchants/#{params[:id]}/dashboard"
    else
      redirect_to "/"
      flash[:alert] = "No merchant found with that ID"
    end
  end

  def show
    @merchant = Merchant.find(params[:id])
  end
end
