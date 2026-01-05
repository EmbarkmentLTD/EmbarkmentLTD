class QuotationMailer < ApplicationMailer
  def quotation_request(quotation_data)
    @quotation_data = quotation_data
    @user = quotation_data[:user]
    @items = quotation_data[:items]
    
    mail(
      to: 'quotations@embarkmentltd.com', # Your company email
      subject: "New Quotation Request from #{@user.name}"
    )
  end
end