class PaymentNotification
  include Mongoid::Document
  field :params
  field :status
  field :transaction_id
  
  references_one :adoption
  embeds_one :buyer_info, :class_name => "ContactInfo"

  after_create :mark_as_purchased, :send_confirmation_email

  def buyer_info= params
    info = ContactInfo.new
    info.email = params[:buyer_email] if params[:buyer_email]
    @buyer_info = read_attribute(:buyer_info)
    @buyer_info = info        
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
