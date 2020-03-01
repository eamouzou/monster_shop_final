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

  def create
    @merchant = Merchant.find(params[:merchant_id])
    discount = @merchant.discounts.create(discount_params)
    create_redirect_process(merchant = @merchant, discount)
  end

  private

  def discount_params
    params.permit(:name, :percentage, :threshold)
  end

  def create_redirect_process(merchant, discount)
    redirect_to "/merchant/#{merchant.id}/discounts" if discount.save == true
    create_save_error(merchant, discount) if discount.save == false
  end

  def create_save_error(merchant, discount)
    flash[:error] = discount.errors.full_messages.to_sentence
    redirect_to "/merchant/#{merchant.id}/discounts/new"
  end
end
