class PaymentNotificationMailer < ActionMailer::Base
  default :from => "laspluviosillas@gmail.com"
  def payment_email(payment)
    @payment = payment
    @adoption = payment.adoption
    mail(:to => "laspluviosillas@gmail.com",
         :subject => "RRSertoma - Your payment has been processed (paypal testing)")
    
    mail(:to => "mstrong@thestrongfamily.org",
         :subject => "RRSertoma - Your payment has been processed (paypal testing)")    
  end
end