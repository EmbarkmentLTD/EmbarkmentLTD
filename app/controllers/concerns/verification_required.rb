module VerificationRequired
  extend ActiveSupport::Concern

  included do
    before_action :check_verification, if: :user_signed_in?
  end

  private

  def check_verification
    # Skip for admin/support users
    return if current_user.admin? || current_user.support?
    
    # Skip for verification controller
    return if controller_name == 'verifications'
    
    # Skip for these actions/pages
    allowed_controllers = ['sessions', 'registrations', 'passwords', 'pages']
    allowed_paths = [root_path, products_path, product_path(:id)]
    
    return if allowed_controllers.include?(controller_name)
    return if allowed_paths.include?(request.path)
    return if request.path.start_with?('/products/') && action_name == 'show'
    
    # Check if user needs verification
    unless current_user.email_verified?
      # Store the intended destination
      store_location_for(:user, request.path) unless request.xhr?
      
      # Redirect to verification page with warning
      if request.format.html?
        redirect_to verification_path, 
                    alert: "Please verify your email to access this feature. Check your email for a 6-digit code."
      else
        render json: { error: "Email verification required" }, status: :forbidden
      end
    end
  end
end