class AdoptionsController < ApplicationController
  inherit_resources

  belongs_to :user, :optional => :true

  before_filter :authenticate_user!, :only => :index
end