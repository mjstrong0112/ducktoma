class Settings < ActiveRecord::Base

  acts_as_singleton
  attr_accessible :id, :adoptions_live, :duck_inventory

  def self.save
    instance.save
  end

  def self.[] arg
    instance[arg]
  end

end