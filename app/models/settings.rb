class Settings < ActiveRecord::Base

  acts_as_singleton
  attr_accessible :id, :adoptions_live, :duck_inventory, :custom_site_message

  # 3 options for canned site message
  #  -- completed_sales: Shows sales completed message
  #  -- maintenance: Shows maintenance message.
  #  -- custom: Use custom message instead of canned.
  attr_accessible :canned_site_message

  def self.save
    instance.save
  end

  def self.[] arg
    instance[arg]
  end

end