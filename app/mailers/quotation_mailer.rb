class QuotationMailer < ApplicationMailer
  def quotation_request(quotation_data)
    @quotation_data = quotation_data
    @user = quotation_data[:user]
    @items = quotation_data[:items]
    @contact_name = quotation_data[:contact_name].presence || @user&.name
    @contact_email = quotation_data[:contact_email].presence || @user&.email
    @contact_phone = quotation_data[:contact_phone].presence
    @company = quotation_data[:company].presence
    @delivery_info = quotation_data[:delivery_info].presence
    @order_details = quotation_data[:order_details].presence
    @timeframe = quotation_data[:timeframe].presence
    @delivery_terms = quotation_data[:delivery_terms].presence
    @special_requirements = quotation_data[:special_requirements].presence

    mail(
      to: "quotations@embarkmentltd.com",
      subject: "New Quotation Request from #{@contact_name}"
    )
  end
end
