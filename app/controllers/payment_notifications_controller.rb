class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]
  def create    
    notification = PaymentNotification.new(:params => params, :status => params[:payment_status], :transaction_id => params[:txn_id])
    if Adoption.find(params[:invoice])
      notification.adoption = Adoption.find(params[:invoice])
    end  
    notification.payer_info = params
    notification.save!
    #Test emails for paypal sandbox
    PaymentNotificationMailer.payment_email(notification,'laspluviosillas@gmail.com').deliver
    PaymentNotificationMailer.payment_email(notification,'mstrong@thestrongfamily.org').deliver
    PaymentNotificationMailer.payment_email(notification,'paul@thestrongfamily.org').deliver
    render :nothing => true
  end
end