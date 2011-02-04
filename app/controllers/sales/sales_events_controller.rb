class Sales::SalesEventsController < ApplicationController
  inherit_resources
  actions :index, :new, :create, :edit, :update, :destroy
  load_and_authorize_resource
  create! { new_sales_sales_event_adoption_path(@sales_event) }
end
