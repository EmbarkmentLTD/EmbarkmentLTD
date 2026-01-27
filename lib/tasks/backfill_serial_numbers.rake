# lib/tasks/backfill_serial_numbers.rake
namespace :db do
  desc "Backfill serial numbers for existing products and users"
  task backfill_serial_numbers: :environment do
    puts "Backfilling user serial numbers..."
    User.where(serial_number: nil).find_each do |user|
      user.update_column(:serial_number, SerialNumberGenerator.generate_for("user"))
    end

    puts "Backfilling product serial numbers..."
    Product.where(serial_number: nil).find_each do |product|
      product.update_column(:serial_number, SerialNumberGenerator.generate_for("product"))
    end

    puts "Serial numbers backfilled successfully!"
  end
end
