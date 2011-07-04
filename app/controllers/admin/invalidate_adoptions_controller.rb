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
    adoptions = Adoption.where(:created_at.lte => date, :state => "pending")
    adoptions.each {|adoption| adoption.state = "invalid"; adoption.save! }

    # Adoptions with a state of new that are paypal never even got past the confirmation page.
    # There's nothing to wait for with these adoptions, so they should always be invalidated.
    adoptions = Adoption.where(:state => "new", :type => :std)
    adoptions.each {|adoption| adoption.state = "invalid"; adoption.save! }

    flash[:notice] = "Adoption invalidation successful!"
    redirect_to admin_root_url
  end
end

