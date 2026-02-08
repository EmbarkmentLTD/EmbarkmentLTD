class Admin::QuotationRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @quotation_requests = QuotationRequest.includes(:user).order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @quotation_request = QuotationRequest.includes(quotation_items: :product, user: {}).find(params[:id])
  end

  private

  def require_admin
    redirect_to root_path, alert: "Not authorized." unless current_user.admin?
  end
end
