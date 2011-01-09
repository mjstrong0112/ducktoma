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
    @payer_info = read_attribute(:payer_info)
    @payer_info = info        
  end
  
  private
  def mark_as_purchased
    if status == "Completed"
      adoption.state = 'completed'
      adoption.save!
    end
  end
  def send_confirmation_email
    
  end
end
