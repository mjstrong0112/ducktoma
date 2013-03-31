class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]
  def create
    
    notification = PaymentNotification.new(:params => params,
                                           :status => params[:payment_status],
                                           :transaction_id => params[:txn_id],
                                           :invoice => params[:invoice])

    # mongodb is loud. If we pass in a invalid value to the search, an exception is thrown
    # instead of just getting a nil/false value in return. hence the rescue begin block
    begin
      adoption = Adoption.find(params[:invoice])
    rescue
      adoption = nil
    end

    # if the adoption doesn't exist, then the payment notification has an invalid
    # invoice and needs to be marked as an orphan.
    if adoption
      notification.adoption = adoption
    else
      notification.make_orphan
    end

    notification.payer_info_params = params

    # Set IPN to unauthorized if the webservice call was forged.
    unless verify_secret(params[:secret])
      notification.make_unauthorized
    end

    notification.save!
    render :nothing => true
  end

  # Verify validity of IPN notification to protect from forgery.
  def verify_secret(secret)
    unless secret == PAYPAL['secret']      
      false
    else
      true
    end    
  end
  
end