class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_order, only: [:show, :update]

  def index
    @orders = Order.all.includes(:user).order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
  end

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: 'Order updated successfully.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def require_admin
    redirect_to root_path, alert: 'Not authorized.' unless current_user.admin?
  end

  def order_params
    params.require(:order).permit(:status, :shipping_address)
  end
end