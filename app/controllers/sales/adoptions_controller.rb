class Sales::AdoptionsController < ApplicationController
  inherit_resources
  actions :index, :show, :new, :create

  belongs_to :user, :optional => :true

  before_filter :authenticate_user!, :only => :index
end