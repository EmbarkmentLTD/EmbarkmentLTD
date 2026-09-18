require "test_helper"

class QuotationMailerTest < ActionMailer::TestCase
  test "quotation email renders contact, delivery and item details in a consistent order" do
    supplier = User.create!(
      name: "Supplier User",
      email: "supplier.mailer@gmail.com",
      password: "Password123!",
      password_confirmation: "Password123!",
      role: "supplier",
      location: "Lagos"
    )

    product = supplier.products.new(
      name: "Fresh Tomatoes",
      description: "Tomatoes",
      category: "vegetables",
      price: 4.50,
      stock_quantity: 10,
      unit: "kg",
      location: "Lagos"
    )
    product.images.attach(
      io: StringIO.new("fake-image-content"),
      filename: "fresh-tomatoes.png",
      content_type: "image/png"
    )
    product.save!

    data = {
      user: supplier,
      items: { product => 3 },
      contact_name: "Buyer User",
      contact_email: "buyer.mailer@gmail.com",
      contact_phone: "+2348000000000",
      company: "Embarkment Ltd",
      delivery_info: "12 Market Road\nLagos\nNigeria",
      order_details: "Need 3kg packed in crates",
      timeframe: "Within 2 weeks",
      delivery_terms: "FOB",
      special_requirements: "Keep them cool"
    }

    email = QuotationMailer.quotation_request(data)
    html = email.body.to_s

    assert_includes html, "Contact Information"
    assert_includes html, "Delivery Information"
    assert_includes html, "Order Summary"
    assert_includes html, "Fresh Tomatoes"
    assert_operator html.index("Contact Information"), :<, html.index("Delivery Information")
    assert_operator html.index("Delivery Information"), :<, html.index("Order Summary")
    assert_operator html.index("Order Summary"), :<, html.index("Items Requested")
  end
end
