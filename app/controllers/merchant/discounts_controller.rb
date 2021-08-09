class Merchant::DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @holidays = DateSwaggerService.new.next_three_holidays
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.discounts.create(discount_params)

    redirect_to merchant_discounts_path(merchant)
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.discounts.find(params[:id])
    discount.update(discount_params)

    redirect_to merchant_discount_path(merchant, discount)
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    Discount.destroy(params[:id])
    redirect_to merchant_discounts_path(merchant)
  end

  private
  def discount_params
    params.require(:discount).permit(:percentage_discount, :quantity_threshold)
  end
end
