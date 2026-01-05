# app/services/serial_number_generator.rb
class SerialNumberGenerator
  # Format: TYPE-YEAR-MONTH-SEQUENCE
  # Example: PROD-2024-10-0001, USER-2024-10-0001
  
  def self.generate_for(record_type)
    prefix = case record_type.to_s.downcase
             when 'product' then 'PROD'
             when 'user' then 'USER'
             else 'GEN'
             end
    
    current_date = Time.current
    year = current_date.year
    month = current_date.strftime('%m')
    
    # Find the last serial number for this type and month
    last_serial = find_last_serial_number(prefix, year, month)
    sequence = last_serial ? last_serial.split('-').last.to_i + 1 : 1
    
    "#{prefix}-#{year}-#{month}-#{sequence.to_s.rjust(4, '0')}"
  end
  
  private
  
  def self.find_last_serial_number(prefix, year, month)
    pattern = "#{prefix}-#{year}-#{month}-%"
    
    if prefix == 'PROD'
      Product.where("serial_number LIKE ?", pattern).order(serial_number: :desc).first&.serial_number
    elsif prefix == 'USER'
      User.where("serial_number LIKE ?", pattern).order(serial_number: :desc).first&.serial_number
    end
  end
end