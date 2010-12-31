require 'singleton'

class Settings
  include Singleton
  include Mongoid::Document

  extend SingleForwardable
  def_delegators :instance, :[], :[]=, :read_attribute, :write_attribute, :write_attributes, :remove_attribute,
                 :save, :changed?

  field :duck_inventory, :type => Integer, :default => 200000

  validates_presence_of :duck_inventory
  validates_numericality_of :duck_inventory, :only_integer => true, :greater_than_or_equal_to => 0
  
  def initialize(*args)
    @settings ||= Settings.first
    if !@settings.nil?
      @attributes = @settings.attributes
      @settings   = super(@attributes)
      self.new_record = nil
    else
      @settings = super(*args)
      self.save!
    end
    @settings
  end
end