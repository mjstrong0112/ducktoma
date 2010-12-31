require 'singleton'

class Settings
  include Singleton
  include Mongoid::Document

  extend SingleForwardable
  def_delegators :instance, :[], :[]=, :read_attribute, :write_attribute, :write_attributes, :remove_attribute,
                 :save, :changed?
  
  def initialize(*args)
    @settings ||= Settings.first
    if !@settings.nil?
      @attributes = @settings.attributes
      @settings   = super(@attributes)
    else
      @settings = super(*args)
      self.save!
    end
    @settings
  end
end