class Admin::AdoptionsController < ApplicationController
  inherit_resources
  actions :index

  belongs_to :user, :optional => :true

  before_filter :authenticate_user!, :only => :index  
end
