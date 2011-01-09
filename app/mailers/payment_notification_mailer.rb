class PaymentNotificationMailer < ActionMailer::Base
  default :from => "laspluviosillas@gmail.com"
  def payment_email(payment,email)
    @payment = payment
    @adoption = payment.adoption
    mail(:to => email,
         :subject => "RRSertoma - Your payment has been processed (paypal testing)")            
  end
end