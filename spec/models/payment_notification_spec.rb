require 'spec_helper'

describe PaymentNotification do
  should_have_field :params
  should_have_field :status
  should_have_field :transaction_id
  
  should_embed_one :buyer_info
  should_reference_one :adoption
end
