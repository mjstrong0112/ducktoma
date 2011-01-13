class PaymentNotificationMailer < ActionMailer::Base
  default :from => "laspluviosillas@gmail.com"
  def payment_email(adoption,email)
    @adoption = adoption
    mail(:to => email,
         :subject => "RRSertoma - Your payment has been processed (paypal testing)")            
  end
end