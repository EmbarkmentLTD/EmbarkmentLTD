module RateLimitable
  extend ActiveSupport::Concern

  class_methods do
    # e.g. `before_action :enforce_rate_limit, only: :create` after `rate_limit max: 20, within: 30.minutes`
    def rate_limit(max:, within: 1.hour)
      @rate_limit_max = max
      @rate_limit_window = within
    end

    def rate_limit_max
      @rate_limit_max
    end

    def rate_limit_window
      @rate_limit_window || 1.hour
    end
  end

  private

  def enforce_rate_limit
    key = "rate:#{controller_name}:#{action_name}:#{request.remote_ip}"
    count = Rails.cache.read(key).to_i

    if count >= self.class.rate_limit_max
      respond_to do |format|
        format.html { redirect_to root_path, alert: "Too many requests. Please try again later." }
        format.json { render json: { error: "Too many requests" }, status: :too_many_requests }
      end
      return
    end

    Rails.cache.write(key, count + 1, expires_in: self.class.rate_limit_window)
  end
end
