class OrdersController < ApplicationController
  @@shirt_item_id = 1
  @@shirt_options = {
    XS: 1,
    S: 2,
    M: 3,
    L: 4,
    XL: 5
  }
  
  def index_shirts
    @order = order_with_item_id @@shirt_item_id
    @options = @@shirt_options
    @orders = Order.where.not(option: "")
  end
  
  def update
    if params[:order][:item_id].to_i == @@shirt_item_id
      @order = order_with_item_id params[:order][:item_id]
      @order.option = @@shirt_options.has_value?(params[:order][:option].to_i) ? params[:order][:option] : nil
      flash.notice = t("orders.saved") if @order.save
    end
    redirect_to shirts_path
  end
  
  private
  
  def order_with_item_id(id)
    @_user.orders.first_or_initialize(item_id: id)
  end
end