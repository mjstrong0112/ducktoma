class AdoptionsController < ApplicationController
  inherit_resources

  before_filter :authenticate_user!

  def begin_of_association_chain
    current_user
  end
end