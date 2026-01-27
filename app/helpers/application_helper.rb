module ApplicationHelper
  def format_price(price)
    number_to_currency(price, unit: "£")
  end

  def format_date(date)
    date&.strftime("%d %B, %Y")
  end

  def cart_items_count
    session[:cart]&.values&.sum || 0
  end

  def featured_categories
    Product::CATEGORIES.first(4)
  end

  def product_image_url(product, size: :medium)
    if product.primary_image
      url_for(product.primary_image)
    else
      "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='200' height='200' viewBox='0 0 200 200'%3E%3Crect width='200' height='200' fill='%23f3f4f6'/%3E%3Ctext x='50%25' y='50%25' dominant-baseline='middle' text-anchor='middle' font-size='48' fill='%239ca3af'%3E#{product.category_icon}%3C/text%3E%3C/svg%3E"
    end
  end

  # Safe rating display
  def display_rating(product)
    product.average_rating.round(1)
  end

  def initials(name)
    name.split.map { |word| word[0] }.join.upcase
  end

  def quotation_items_count
    session[:quotation]&.values&.sum || 0
  end

  def display_star_rating(product)
    product.star_rating
  end

  def has_ratings?(product)
    product.has_ratings?
  end

  def order_status_color(status)
  status = status.to_s
  case status
  when "pending"
    "bg-yellow-100 text-yellow-800"
  when "confirmed"
    "bg-blue-100 text-blue-800"
  when "shipped"
    "bg-purple-100 text-purple-800"
  when "delivered"
    "bg-green-100 text-green-800"
  when "cancelled"
    "bg-red-100 text-red-800"
  else
    "bg-gray-100 text-gray-800"
  end
end
end
