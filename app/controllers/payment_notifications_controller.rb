class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]
  def create    
    notification = PaymentNotification.new(:status => params[:payment_status], :transaction_id => params[:txn_id])
    if Adoption.find(params[:invoice])
      notification.adoption = Adoption.find(params[:invoice])
    end  
    notification.buyer_info = params
    notification.save!
    PaymentNotificationMailer.payment_email(notification).deliver
    render :nothing => true
  end
end