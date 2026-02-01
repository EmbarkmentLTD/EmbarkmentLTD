class QuotationsController < ApplicationController
  before_action :authenticate_user!

  def cart
    if params[:product_id].present?
      product = Product.find_by(id: params[:product_id])
      if product
        session[:quotation] ||= {}
        quantity = params[:quantity].presence || 1
        session[:quotation][product.id.to_s] = quantity.to_i
      end
    end

    @quotation_items = get_quotation_items
  end

  def submit_email_quotation
      @quotation_items = get_quotation_items

  # Server-side validation
  if @quotation_items.empty?
    redirect_to quotation_cart_path, alert: "Please add at least one product to your quotation request."
    return
  end

    # Debug: Check what we're receiving
    Rails.logger.info "Quotation params: #{quotation_params.inspect}"
    Rails.logger.info "Quotation items: #{@quotation_items.inspect}"

  # Rest of your submission logic
  quotation_data = {
    user: current_user,
    items: @quotation_items,
    contact_name: quotation_params[:contact_name],
    contact_email: quotation_params[:contact_email],
    contact_phone: quotation_params[:contact_phone],
    company: quotation_params[:company],
    delivery_street: quotation_params[:delivery_street],
    delivery_city: quotation_params[:delivery_city],
    delivery_state: quotation_params[:delivery_state],
    delivery_zip: quotation_params[:delivery_zip],
    delivery_country: quotation_params[:delivery_country],
    order_details: quotation_params[:order_details],
    timeframe: quotation_params[:timeframe],
    delivery_terms: quotation_params[:delivery_terms],
    special_requirements: quotation_params[:special_requirements]
  }

    quotation_request = QuotationRequest.create!(quotation_data.except(:items))
    @quotation_items.each do |product, quantity|
      quotation_request.quotation_items.create!(product: product, quantity: quantity)
    end

    # In production, you would send an email here
    # QuotationMailer.quotation_request(quotation_data).deliver_later
    Rails.logger.info "Quotation request received: #{quotation_data}"

    first_item = @quotation_items.first
    if first_item
      product, quantity = first_item
      redirect_to quotation_product_path(product, quantity: quantity, quotation_request_id: quotation_request.id), notice: "Quotation request ready. Choose email or WhatsApp to send."
    else
      redirect_to quotation_cart_path, alert: "Please add at least one product to your quotation request."
    end
  end

  def remove_quotation_item
    product_id = params[:product_id]
    session[:quotation].delete(product_id)
    redirect_to quotation_cart_path, notice: "Item removed from quotation request."
  end

  private

  def get_quotation_items
  return {} unless session[:quotation].is_a?(Hash)

  quotation = session[:quotation]
  items = {}

  quotation.each do |product_id, quantity|
    begin
      product = Product.find(product_id)
      items[product] = quantity.to_i if product
    rescue ActiveRecord::RecordNotFound
      # Skip products that no longer exist
      next
    end
  end

  items
end

  def quotation_params
  # Remove the .require(:quotation) since your form fields are not nested
  params.permit(
    :contact_name, :contact_email, :contact_phone, :company,
    :delivery_street, :delivery_city, :delivery_state, :delivery_zip, :delivery_country,
    :order_details, :timeframe, :delivery_terms, :special_requirements
  )
  end
end
