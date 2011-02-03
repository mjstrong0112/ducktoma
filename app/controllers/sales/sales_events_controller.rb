class Sales::SalesEventsController < ApplicationController
  inherit_resources
  actions :index, :new, :create, :edit, :update, :destroy
  load_and_authorize_resource
  def index
    index!
  end
end
