class PaymentNotification
  include Mongoid::Document
  include Mongoid::Timestamps
  field :params, :type => Hash

  #Paypal state
  field :status

  field :transaction_id
  field :invoice 

  references_one :adoption
  embeds_one :payer_info, :class_name => "ContactInfo"

  after_create :mark

  scope :unauthorized, where(:state =>'unauthorized')
  scope :orphans, where(:state => 'orphan')
  scope :completed, where(:state =>'completed')

  #Our state
  field :state, :type => String, :default => "new"


  #state_machine :initial => :new do
  #  event :orphan do
  #    transition :new => :orphan
  #  end
  #  event :failed do
  #    transition :new => :failed
  #  end
  # event :unauthorized do
  #    transition :new => :unauthorized
  #  end
  #  event :completed do
  #    transition :new => :completed
  #  end
  #end

  def payer_info_params= params
    info = ContactInfo.new
    info.email = params[:payer_email] if params[:payer_email]
    info.full_name = params[:first_name] + ' ' + params[:last_name] if params[:first_name] && params[:last_name]
    info.phone = params[:contact_phone] if params[:contact_phone]
    info.city = params[:address_city] if params[:address_city]
    info.state = params[:address_state] if params[:address_state]
    info.address = params[:address_street] if params[:address_street]
    info.zip = params[:address_zip].to_i if params[:address_zip]
    self.payer_info = info    
  end

  def make_unauthorized
    self.state = 'unauthorized'
  end
  def make_orphan
    self.state = 'orphan'    
  end
  def send_unauthorized_access_email
    PaymentNotificationMailer.unauthorized_access_email(self,'laspluviosillas@gmail.com').deliver
    PaymentNotificationMailer.unauthorized_access_email(self,'mstrong@thestrongfamily.org').deliver
    PaymentNotificationMailer.unauthorized_access_email(self,'paul@thestrongfamily.org').deliver
  end

  def send_confirmation_email
    #Test emails for paypal sandbox
    PaymentNotificationMailer.payment_email(adoption,'laspluviosillas@gmail.com').deliver
    PaymentNotificationMailer.payment_email(adoption,'mstrong@thestrongfamily.org').deliver
    PaymentNotificationMailer.payment_email(adoption,'paul@thestrongfamily.org').deliver

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
  def payer_info_copy
    info = ContactInfo.new
    info.email = self.payer_info.email
    info.full_name = self.payer_info.full_name
    info.phone = self.payer_info.phone
    info.city = self.payer_info.city
    info.state = self.payer_info.state
    info.address = self.payer_info.address
    info.zip = self.payer_info.zip
    info
  end
  def mark
    unless state == 'unauthorized'
      if status == "Completed" && valid_state?
        send_confirmation_email
        self.state = 'completed'
        save!

        adoption.state = 'completed'
        adoption.adopter_info = payer_info_copy
        adoption.save!        
      elsif status == "Denied"
        #TODO: Handle denied paypal payment
        #send_failed_email
      end
    else
      send_unauthorized_access_email
    end
  end
  #def send_failed_email
  #
  #end
end
