class PaymentNotificationMailer < ActionMailer::Base
  default :from => "laspluviosillas@gmail.com"
  def payment_email(adoption,email)
    @adoption = adoption
    mail(:to => email, :subject => "RRSertoma - Your payment has been processed")            
  end
  def unauthorized_access_email(notification, email)
    @notification = notification
    mail(:to => email, :subject =>"RRSertoma - Unauthorized IPN request")
  end
end