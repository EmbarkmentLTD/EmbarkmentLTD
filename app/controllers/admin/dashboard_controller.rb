class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @users_count = User.count
    @buyers_count = User.where(role: "buyer").count
    @suppliers_count = User.where(role: "supplier").count
    @products_count = Product.count
    @in_stock_count = Product.where("stock_quantity > 0").count
    @out_of_stock_count = Product.where("stock_quantity <= 0").count
    @quotation_requests_count = QuotationRequest.count
    @reviews_count = Review.count
    @support_messages_count = SupportMessage.count
    @recent_quotation_requests = QuotationRequest.includes(:user).order(created_at: :desc).limit(5)
    @recent_products = Product.includes(:user).order(created_at: :desc).limit(5)

      # Platform Intelligence Features - REAL CALCULATIONS
      @platform_health_score = calculate_platform_health
      @supplier_quality_index = calculate_supplier_quality
      @marketplace_growth = calculate_marketplace_growth
      @category_diversity = calculate_category_diversity

      @top_suppliers = calculate_top_suppliers
      @pending_verifications = Product.where(verified: false).count
      @flagged_reviews = Review.where(flagged: true).count
      @seasonal_recommendations = get_seasonal_recommendations
      @sustainability_metrics = calculate_sustainability_metrics
      # ADD VERIFICATION STATS HERE
      @verified_users = User.where.not(email_verified_at: nil).count
      @unverified_users = User.where(email_verified_at: nil).count
      @verification_rate = @users_count > 0 ? (@verified_users.to_f / @users_count * 100).round(2) : 0
      @recent_unverified = User.where(email_verified_at: nil)
                            .where("created_at > ?", 7.days.ago)
                            .order(created_at: :desc)
                            .limit(10)

    chart_data = build_chart_data
    @signup_labels = chart_data[:signup_labels]
    @signup_series = chart_data[:signup_series]
    @category_labels = chart_data[:category_labels]
    @category_series = chart_data[:category_series]
    @pageview_labels = chart_data[:pageview_labels]
    @pageview_series = chart_data[:pageview_series]
  end

  def charts
    chart_data = build_chart_data
    render json: chart_data
  end

  # Keep the separate action if you want a dedicated page
  def verification_stats
    @total_users = User.count
    @verified_users = User.where.not(email_verified_at: nil).count
    @unverified_users = User.where(email_verified_at: nil).count
    @verification_rate = @total_users > 0 ? (@verified_users.to_f / @total_users * 100).round(2) : 0

    # Recent unverified users
    @recent_unverified = User.where(email_verified_at: nil)
                            .where("created_at > ?", 7.days.ago)
                            .order(created_at: :desc)
  end

  private

  def build_chart_data
    date_range = (29.days.ago.to_date..Date.current).to_a

    signups_by_day = User.where(created_at: 29.days.ago.beginning_of_day..Time.current.end_of_day)
                          .group("DATE(created_at)")
                          .count

    signup_labels = date_range.map { |d| d.strftime("%b %d") }
    signup_series = date_range.map { |d| signups_by_day[d] || 0 }

    category_counts = Product.where(created_at: 29.days.ago.beginning_of_day..Time.current.end_of_day)
                             .group("DATE(created_at)", :category)
                             .count

    top_categories = Product.group(:category)
                           .order(Arel.sql("COUNT(*) DESC"))
                           .limit(5)
                           .count
                           .keys

    category_labels = signup_labels
    category_series = top_categories.index_with do |category|
      date_range.map { |d| category_counts[[ d, category ]] || 0 }
    end

    if PageView.table_exists?
      pageview_counts = PageView.where(viewed_on: date_range)
                               .group(:path)
                               .sum(:count)

      top_paths = pageview_counts.sort_by { |_, count| -count }.first(5).map(&:first)

      pageviews_by_day = PageView.where(viewed_on: date_range, path: top_paths)
                                .group(:viewed_on, :path)
                                .sum(:count)

      pageview_labels = signup_labels
      pageview_series = top_paths.index_with do |path|
        date_range.map { |d| pageviews_by_day[[ d, path ]] || 0 }
      end
    else
      pageview_labels = signup_labels
      pageview_series = {}
    end

    {
      signup_labels: signup_labels,
      signup_series: signup_series,
      category_labels: category_labels,
      category_series: category_series,
      pageview_labels: pageview_labels,
      pageview_series: pageview_series
    }
  end


    def calculate_platform_health
      # Real calculation based on multiple factors
      total_weight = 0
      total_score = 0

      # Factor 1: User activity (40% weight)
      if User.count > 0
        active_users = User.where("updated_at >= ?", 1.month.ago).count
        user_score = (active_users.to_f / User.count * 100).round
        total_score += user_score * 0.4
        total_weight += 0.4
      end

      # Factor 2: Transaction activity (40% weight)
      if Order.count > 0
        recent_orders = Order.where("created_at >= ?", 1.month.ago).count
        order_score = (recent_orders.to_f / Order.count * 100).round
        total_score += order_score * 0.4
        total_weight += 0.4
      end

      # Factor 3: Product activity (20% weight)
      if Product.count > 0
        active_products = Product.where("stock_quantity > 0").count
        product_score = (active_products.to_f / Product.count * 100).round
        total_score += product_score * 0.2
        total_weight += 0.2
      end

      # Calculate final score
      total_weight > 0 ? (total_score / total_weight).round : 0
    end

    def calculate_supplier_quality
      # Real calculation of average supplier rating
      supplier_ratings = Review.joins(:product)
                              .where(products: { user_id: User.suppliers.select(:id) })
                              .average(:rating)

      supplier_ratings ? supplier_ratings.round(1) : 0.0
    end

    def calculate_marketplace_growth
      # Real calculation of user growth percentage
      current_month_users = User.where("created_at >= ?", Time.current.beginning_of_month).count
      previous_month_users = User.where(
        "created_at >= ? AND created_at < ?",
        1.month.ago.beginning_of_month,
        Time.current.beginning_of_month
      ).count

      if previous_month_users > 0
        growth = ((current_month_users - previous_month_users).to_f / previous_month_users * 100).round
        growth
      else
        current_month_users > 0 ? 100 : 0
      end
    end

    def calculate_category_diversity
      # Real calculation of category coverage
      all_categories = [ "vegetables", "fruits", "grains", "dairy", "meat", "seafood", "herbs", "other" ]
      active_categories = Product.select("DISTINCT category").where(category: all_categories).count

      (active_categories.to_f / all_categories.count * 100).round
    end

    def calculate_top_suppliers
      User.suppliers.joins(:products)
          .left_joins(:reviews)
          .select('users.*,
                   COUNT(DISTINCT products.id) as product_count,
                   COALESCE(AVG(reviews.rating), 0) as average_rating,
                   COUNT(DISTINCT reviews.id) as review_count')
          .group("users.id")
          .order("product_count DESC, average_rating DESC")
          .limit(5)
    end

    def get_seasonal_recommendations
      current_month = Time.current.month
      case current_month
      when 12, 1, 2
        { season: "Winter", focus: "Root vegetables, citrus fruits, greenhouse produce" }
      when 3, 4, 5
        { season: "Spring", focus: "Leafy greens, berries, early vegetables" }
      when 6, 7, 8
        { season: "Summer", focus: "Tomatoes, corn, stone fruits, melons" }
      when 9, 10, 11
        { season: "Fall", focus: "Apples, squash, pumpkins, root vegetables" }
      end
    end

    def calculate_sustainability_metrics
      # Real calculations based on your data
      local_products = Product.where("location ILIKE ?", "%local%").count
      organic_products = Product.where(is_organic: true).count
      total_products = Product.count

      # Estimate environmental impact
      carbon_saved = (local_products * 85) + (organic_products * 25) # kg CO2
      water_saved = (local_products * 55000) + (organic_products * 15000) # liters
      local_farmers = User.suppliers.distinct.count

      {
        carbon_saved: carbon_saved,
        water_saved: water_saved,
        local_farmers: local_farmers
      }
    end


    def require_admin
    redirect_to root_path, alert: "Not authorized." unless current_user.admin?
    end
end
