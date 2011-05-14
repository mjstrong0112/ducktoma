class Admin::InvalidateAdoptionsController < ApplicationController
  def index
  end
  def confirm
    date = Date.strptime(params[:invalidate][:date], "%m-%d-%Y")
    @adoptions = Adoption.where(:created_at.lte => date, :state => "pending")
    @date = params[:invalidate][:date]
  end
  def invalidate
    date = Date.strptime(params[:date], "%m-%d-%Y")
    @adoptions = Adoption.where(:created_at.lte => date, :state => "pending")
    @adoptions.each {|adoption| adoption.state = "invalid"; adoption.save! }
    flash[:notice] = "Adoption invalidation successful!"
    redirect_to admin_root_url
  end
end

