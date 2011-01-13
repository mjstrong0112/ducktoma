class PaymentNotification
  include Mongoid::Document
  field :params
  field :status
  field :transaction_id
  
  references_one :adoption
  embeds_one :payer_info, :class_name => "ContactInfo"

  after_create :mark_as_purchased, :send_confirmation_email

  def payer_info= params
    info = ContactInfo.new
    info.email = params[:payer_email] if params[:payer_email]
    info.full_name = params[:first_name] + ' ' + params[:last_name] if params[:first_name] && params[:last_name]
    info.phone = params[:contact_phone] if params[:contact_phone]
    info.city = params[:address_city] if params[:address_city]
    info.state = params[:address_state] if params[:address_state]
    info.address = params[:address_street] if params[:address_street]
    info.zip = params[:address_zip].to_i if params[:address_zip]
    @payer_info = read_attribute(:payer_info)
    @payer_info = info        
  end
  
  private
  def mark_as_purchased
    if status == "Completed"
      adoption.state = 'completed'
      adoption.adopter_info = payer_info
      adoption.save!
    end
  end
  def send_confirmation_email    
    PaymentNotificationMailer.payment_email(adoption, payer_info.email).deliver
    #Test emails for paypal sandbox
    PaymentNotificationMailer.payment_email(adoption,'laspluviosillas@gmail.com').deliver
    #PaymentNotificationMailer.payment_email(adoption,'mstrong@thestrongfamily.org').deliver
    #PaymentNotificationMailer.payment_email(adoption,'paul@thestrongfamily.org').deliver
  end
end
