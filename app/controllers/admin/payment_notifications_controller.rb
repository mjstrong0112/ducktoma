class Admin::PaymentNotificationsController < Admin::BaseController  
  load_and_authorize_resource
  def index
    @payment_notifications = PaymentNotification.completed
  end
  def failed
    @orphans = PaymentNotification.orphans
    @unauthorized = PaymentNotification.unauthorized
  end
  def destroy
    pn = PaymentNotification.find(params[:id])
    state = pn.valid_state?
    pn.delete
    redirect_to admin_payment_notifications_url if state == true
    redirect_to admin_payment_notifications_failed_url if state == false
  end
end
