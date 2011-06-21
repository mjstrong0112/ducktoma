class Admin::AdoptionsController < Admin::BaseController
  inherit_resources
  actions :index
  load_and_authorize_resource :only => [:index]

  def index
    all_ids = Adoption.paid.only(:id).map(&:id)
    @total_donations = Adoption.paid.sum(:fee)
    @total_ducks = Duck.where(:adoption_id.in => all_ids).count
    @adoptions = Adoption.valid.paginate(:page => params[:page] ||= 1, :per_page => 20)
  end

  require 'csv'
  def export_csv
    @ducks = Duck.all.only([:adoption_id, :number]).order_by([:number, :asc]).group_by(&:adoption_id)
    csv_string = CSV.generate do |csv|
      # Headers
      csv << ['Adoption Number', 'Duck count','Fee', 'First Duck']
      Adoption.paid.order_by([:adoption_number, :asc]).each do |adoption|
        ducks = adoption.ducks
        values = [adoption.adoption_number, @ducks[adoption.id].count, "$" + adoption.dollar_fee.to_s, @ducks[adoption.id][0].number]
        csv << values
      end
    end

    send_data csv_string, :type => "text/plain", :filename => "report.csv", :disposition => 'attachment'
  end

  # Due to an oversight, the first version of ducktoma didn't have
  # validates_uniqueness_of :adoption_number for Adoptions.
  # This led to some unwanted duplicates in prod.
  #
  # This function was coded to get rid of the duplicates present in production.
  #
  # Adoptions now DO validate the uniqueness of their adoption_number,
  # so even though this function will probably never be run again,
  # I decided to keep it, just in case.

  def find_duplicates
    @duplicate_adoptions = get_duplicates
  end

  def remove_duplicates
    duplicate_adoptions = get_duplicates
    duplicate_adoptions.each do |duplicate|
      duplicate.delete
    end

    flash[:notice] = "Duplicates successfully removed!"
    redirect_to admin_root_url
  end

  private
  def get_duplicates
    # Find all adoption numbers that are duplicated in the db.
    duplicate_numbers = duplicates Adoption.only(:adoption_number).map(&:adoption_number)

    # Get the full adoption objects corresponding to the duplicate_numbers found.
    adoptions = Adoption.where(:adoption_number.in => duplicate_numbers).to_a

    # The action above returns all objects for duplicate numbers in the database,
    # which means it will return two or more objects for each number in the duplicate_numbers array.
    # We only want to show - one - entry for each duplicate adoption.
    # So, the line below removes the duplicates of the duplicates.
    duplicate_adoptions = adoptions.uniq_by(&:adoption_number)
  end

end
