class Admin::AdoptionsController < Admin::BaseController    
  load_and_authorize_resource :only => [:index]

  def index
    @total_donations = Adoption.paid.select(&:fee).sum(&:fee)
    @total_ducks = Adoption.paid.joins(:ducks).count
    @adoptions = Adoption.valid.order("created_at asc").paginate(:page => params[:page] ||= 1, :per_page => 20)
  end

  require 'csv'
  def export_by_adoption_number
    headers = ['Adoption Number', 'Duck count','Fee', 'First Duck']
    csv_string = to_csv headers, :number do |a, csv|
                   csv << [a.number, a.duck_count, "$" + a.dollar_fee.to_s, a.first_number]   
                 end
    send_data csv_string, :type => "text/plain", :filename => "report.csv", :disposition => 'attachment'
  end

  def export_by_name
    headers = ['Name','Adoption Number', 'First Duck', 'Duck count']
    csv_string = to_csv headers, :full_name do |a, csv|
                   csv << [a.full_name, a.adoption_number, a.first_number, a.duck_count]
                 end
    send_data csv_string, :type => "text/plain", :filename => "report.csv", :disposition => 'attachment'
  end

  def export_by_duck_number
    headers = ['Duck Number', 'Full Name', 'Adoption Number']
    csv_string = to_csv headers, :number do |a, csv|
                   a.ducks.each { |d| csv << [d.number, a.full_name, a.number] }
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

  def to_csv headers, sort, &block
    csv_string = CSV.generate do |csv|
      # Headers
      csv << headers
      Adoption.valid.includes(:ducks).order(sort).each { |a| 
        yield(a, csv)
      }
    end
  end

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
