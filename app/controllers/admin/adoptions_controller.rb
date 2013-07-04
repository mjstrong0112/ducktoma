class Admin::AdoptionsController < Admin::BaseController

  load_and_authorize_resource :only => [:index]
  sortable_for :adoption

  def index
    @total_donations = Adoption.paid.select(&:fee).sum(&:fee)
    @total_ducks = Adoption.paid.joins(:ducks).count
    @adoptions = Adoption.valid.with_duck_count.sort(sort_column, sort_direction)
                         .paginate(:page => params[:page] ||= 1)
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

end