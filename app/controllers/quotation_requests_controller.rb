class QuotationRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @quotation_requests = current_user.quotation_requests.includes(:quotation_items).order(created_at: :desc)
  end

  def show
    @quotation_request = current_user.quotation_requests.includes(quotation_items: :product).find(params[:id])
  end
end
