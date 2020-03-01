class OrdersController < ApplicationController

  def new
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    create_order
  end

  def index
    @user = current_user
  end

  def update
    update_order
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end

  def create_order
    order = current_user.orders.create(order_params)
    create_order_process(user = current_user, order)
  end

  def create_order_process(user, order)
    save_order(user, order) if order.save == true
    save_order_error if order.save == false
  end

  def save_order(user, order)
    create_item_orders(user, order)
    delete_session_and_flash_message(user, order)
    create_order_redirects(user, order)
  end

  def create_item_orders(user, order)
    cart.items.each do |item,quantity|
      order.item_orders.create({item: item, quantity: quantity, price: item.price})
    end
  end

  def delete_session_and_flash_message(user, order)
    session.delete(:cart)
    flash[:success] = "Your order has been placed!"
  end

  def create_order_redirects(user, order)
    if user.role != "regular"
      redirect_to "/profile/orders"
    else
      redirect_to "/orders/#{order.id}"
    end
  end

  def save_order_error
    flash[:notice] = "Please complete address form to create an order."
    render :new
  end

  def update_order
    current_user.orders.find(params[:id]).cancel_process
    redirect_to '/profile/orders'
    flash[:notice] = 'Order has been cancelled.'
  end
end
