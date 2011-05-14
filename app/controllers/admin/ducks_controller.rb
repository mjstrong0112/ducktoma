class Admin::DucksController < ApplicationController
  load_and_authorize_resource

  def show
    @duck = Duck.where(:number => params[:number]).first
    @adoption = @duck.adoption
  end
end
