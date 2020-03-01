class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def edit
    @discount = Discount.find(params[:discount_id])
  end

  def show
    @discount = Discount.find(params[:discount_id])
  end
end
