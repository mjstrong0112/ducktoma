class Admin::DucksController < ApplicationController
  load_and_authorize_resource

  def show
    @duck = Duck.where(:number => params[:number]).first
    @adoption = @duck.adoption
  end

  # Regenerates duck numbers.
  # NOTE: This is a very taxing operation. Use with care.
  # Would like to hear optimization options.
  def regenerate
    # Set invalid adoptions to have a number of -1 since they no longer count.
    Adoption.invalid.each do |adoption|
      adoption.ducks.each do |duck|
        duck.number = -1
        duck.save
      end
    end

    # Regenerate the duck numbers of valid adoptions so that there
    # will be no gaps in the numbers.
    duck_count = 1
    Adoption.valid.each do |adoption|
      adoption.ducks.each do |duck|
        duck.number = duck_count
        duck.save

        duck_count += 1
      end
    end

    redirect_to admin_root_url, :notice => "Duck numbers regenerated successfully!"
  end
end
