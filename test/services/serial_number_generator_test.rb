require "test_helper"

class SerialNumberGeneratorTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::TimeHelpers

  test "generates product serial numbers with the PROD prefix and increments the last value" do
    travel_to Time.zone.local(2026, 9, 19, 12, 0, 0) do
      supplier = User.create!(
        name: "Supplier User",
        email: "supplier.#{SecureRandom.hex(4)}@gmail.com",
        password: "Password123!",
        password_confirmation: "Password123!",
        role: "supplier",
        location: "Lagos"
      )

      product = supplier.products.new(
        name: "Sample Product",
        description: "Sample",
        category: "fruits",
        price: 1.5,
        stock_quantity: 10,
        unit: "kg",
        location: "Lagos"
      )

      product.images.attach(
        io: StringIO.new("fake-image-content"),
        filename: "sample-product.png",
        content_type: "image/png"
      )
      product.save!
      product.update_columns(serial_number: "PROD-2026-09-0007")

      assert_equal "PROD-2026-09-0008", SerialNumberGenerator.generate_for(:product)
    end
  end

  test "generates user serial numbers with the USER prefix" do
    travel_to Time.zone.local(2026, 9, 19, 12, 0, 0) do
      assert_match(/\AUSER-2026-09-\d{4}\z/, SerialNumberGenerator.generate_for(:user))
    end
  end

  test "falls back to the generic prefix for unknown record types" do
    travel_to Time.zone.local(2026, 9, 19, 12, 0, 0) do
      assert_match(/\AGEN-2026-09-\d{4}\z/, SerialNumberGenerator.generate_for(:vendor))
    end
  end
end
