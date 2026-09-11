module ApplicationHelper
  def broken_image_fallback_url
    "data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20width=%22600%22%20height=%22600%22%20viewBox=%220%200%20600%20600%22%3E%3Cdefs%3E%3ClinearGradient%20id=%22g%22%20x1=%220%22%20x2=%221%22%20y1=%220%22%20y2=%221%22%3E%3Cstop%20offset=%220%25%22%20stop-color=%22%23f3f4f6%22/%3E%3Cstop%20offset=%22100%25%22%20stop-color=%22%23e5e7eb%22/%3E%3C/linearGradient%3E%3C/defs%3E%3Crect%20width=%22600%22%20height=%22600%22%20fill=%22url(%23g)%22/%3E%3Crect%20x=%22120%22%20y=%22130%22%20width=%22360%22%20height=%22260%22%20rx=%2220%22%20fill=%22none%22%20stroke=%22%239ca3af%22%20stroke-width=%2214%22/%3E%3Ccircle%20cx=%22220%22%20cy=%22220%22%20r=%2232%22%20fill=%22none%22%20stroke=%22%239ca3af%22%20stroke-width=%2214%22/%3E%3Cpath%20d=%22M150%20350l85-95%2070%2072%2058-62%2085%2085%22%20fill=%22none%22%20stroke=%22%239ca3af%22%20stroke-width=%2214%22%20stroke-linecap=%22round%22%20stroke-linejoin=%22round%22/%3E%3Ctext%20x=%2250%25%22%20y=%22470%22%20text-anchor=%22middle%22%20font-size=%2230%22%20font-family=%22sans-serif%22%20fill=%22%236b7280%22%3EImage%20unavailable%3C/text%3E%3C/svg%3E"
  end

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
