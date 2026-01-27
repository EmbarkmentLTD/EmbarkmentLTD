class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [ :show, :update, :cancel, :confirm, :ship, :deliver ]
  before_action :check_verification_for_orders, only: [ :new, :create ]

  def index
    @orders = current_user.orders.includes(:order_items, :products).order(created_at: :desc)
  end

  def show
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: "Order updated successfully."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def cart
    @cart_items = get_cart_items
    @total_amount = calculate_cart_total
  end

  def checkout
    @cart_items = get_cart_items

    if @cart_items.empty?
      redirect_to cart_orders_path, alert: "Your cart is empty."
      return
    end

    @order = current_user.orders.new(
      total_amount: calculate_cart_total,
      status: "pending",
      shipping_address: current_user.location
    )

    if @order.save
      @cart_items.each do |product, quantity|
        @order.order_items.create!(
          product: product,
          quantity: quantity,
          unit_price: product.price
        )
      end

      session[:cart] = {}
      redirect_to @order, notice: "Order placed successfully!"
    else
      redirect_to cart_orders_path, alert: "Failed to place order."
    end
  end

  def update_cart_item
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    if quantity > 0
      session[:cart][product_id] = quantity
      redirect_to cart_orders_path, notice: "Cart updated."
    else
      remove_cart_item
    end
  end

  def remove_cart_item
    product_id = params[:product_id]
    session[:cart].delete(product_id)
    redirect_to cart_orders_path, notice: "Item removed from cart."
  end

  def cancel
    if @order.can_cancel?
      @order.update(status: "cancelled")
      redirect_to @order, notice: "Order cancelled."
    else
      redirect_to @order, alert: "Cannot cancel this order."
    end
  end

  def my_orders
  @orders = current_user.orders.includes(:order_items, :products).order(created_at: :desc).page(params[:page]).per(10)
  end

  def confirm
  if @order.update(status: "confirmed")
    @order.order_items.each do |item|
      item.product.reduce_stock(item.quantity)
    end
    redirect_to @order, notice: "Order confirmed successfully."
  else
    redirect_to @order, alert: "Failed to confirm order."
  end
end

def ship
  if @order.update(status: "shipped")
    redirect_to @order, notice: "Order marked as shipped."
  else
    redirect_to @order, alert: "Failed to update order status."
  end
end

  def deliver
    if @order.update(status: "delivered")
    redirect_to @order, notice: "Order marked as delivered."
    else
    redirect_to @order, alert: "Failed to update order status."
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def get_cart_items
    cart = session[:cart] || {}
    cart.map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      [ product, quantity ] if product
    end.compact.to_h
  end

  def calculate_cart_total
    get_cart_items.sum { |product, quantity| product.price * quantity }
  end

  def check_verification_for_orders
    if user_signed_in? && !current_user.email_verified?
    redirect_to verification_path,
                alert: "Please verify your email before placing orders."
    end
  end
end
