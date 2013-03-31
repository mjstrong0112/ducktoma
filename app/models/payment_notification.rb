# ====================
# Payment Notification
# ====================
# Model for storing IPN notifications that arrive from PayPal.
# = fields =
#   params:           Stores ALL variables returned from the IPN notification
#                     for future reference.

#   status:           Status variable returned from IPN.
#
#   state:            Status of paypal payment inside ducktoma.
#
#   transaction_id:   Transaction ID returned from IPN.
#
#   invoice:          invoice variable returned from IPN.
#=                    The invoice number should ALWAYS be the same as
#=                    the id of the adoption associated with this payment,
#=                    as this field is used to look up adoptions, mark them
#=                    as completed, and store the contact_info received from IPN
#=                    into the associated adoption.

class PaymentNotification < ActiveRecord::Base

  # == fields ==
  # Paypal values
  attr_accessible :transaction_id, :invoice, :status, :params

  # State of IPN notification. Not to be confused with 'status' above.
  # since 'status' is simply the status value received from the IPN,
  # while 'state' is ducktoma specific.
  # Can be the following values:
  #   Completed:      IPN notification marking payment was successful.
  #
  #   Failed:         Equivalent to Paypal's payment failed IPN status.
  #
  #   Unauthorized:   Attempts at forging IPN notifications are marked as
  #                   Unauthorized when the correct secret key is not passed.
  #
  #   Orphan:         Incomplete list of parameters received from IPN.
  #                   Usually if the adoption associated to this payment
  #                   though its invoice number couldn't be found, the IPN
  #                   will be marked as an orphan.
  attr_accessible :state

  serialize :params

  # == associations ==
  has_one :adoption
  has_one :payer_info, :as => :contact, :class_name => "ContactInfo"


  # == scopes ==
  scope :unauthorized, where(:state =>'unauthorized')
  scope :orphans,      where(:state => 'orphan')
  scope :completed,    where(:state =>'completed')

  # == hooks ==
  after_create :mark


  # Converts IPN value hash into ContactInfo object.
  def payer_info_params= params
    info = ContactInfo.new
    info.email = params[:payer_email]      if params[:payer_email]
    info.full_name = params[:first_name] + ' ' + params[:last_name] if params[:first_name] && params[:last_name]
    info.phone = params[:contact_phone]    if params[:contact_phone]
    info.city = params[:address_city]      if params[:address_city]
    info.state = params[:address_state]    if params[:address_state]
    info.address = params[:address_street] if params[:address_street]
    info.zip = params[:address_zip].to_i   if params[:address_zip]
    self.payer_info = info
  end

  def make_unauthorized
    self.state = 'unauthorized'
  end

  def make_orphan
    self.state = 'orphan'    
  end

  def send_unauthorized_access_email
    PaymentNotificationMailer.unauthorized_access_email(self,'ducksale@rrsertoma.org').deliver
  end

  def send_confirmation_email
    # Test emails for paypal sandbox
    PaymentNotificationMailer.payment_email(adoption,'ducksale@rrsertoma.org').deliver

    #real email
    PaymentNotificationMailer.payment_email(adoption, payer_info.email).deliver
  end  

  def valid_state?
    case state
      when 'completed', 'new' then true
      when 'failed', 'unauthorized', 'orphan' then false
      else false
    end
  end

  private
  # Creates a copy of the payer information to associate with adoptions.
  def payer_info_copy
    ContactInfo.new.tap do |info|
      info.email     = self.payer_info.email
      info.full_name = self.payer_info.full_name
      info.phone     = self.payer_info.phone
      info.city      = self.payer_info.city
      info.state     = self.payer_info.state
      info.address   = self.payer_info.address
      info.zip       = self.payer_info.zip
    end
  end

  def mark
    send_unauthorized_access_email if state == 'unauthorized'
    # TODO: Handle denied paypal payment
    send_failed_email if status == "Denied"

    # If everything went according to plan.
    if status == "Completed" && valid_state?
      self.state = 'completed'
      save!
      # Set adoption to 'completed' and give it
      # the contact_info received from the IPN notification.
      adoption.state = 'completed'
      adoption.adopter_info = payer_info_copy      
      adoption.save!

      send_confirmation_email
    end
  end
end