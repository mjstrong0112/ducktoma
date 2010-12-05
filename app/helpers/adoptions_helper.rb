module AdoptionsHelper
  def total_duck_count
    d_count=0
    Adoption.all.each do |adoption|
      d_count += adoption.duck_count
    end
    d_count
  end
  def total_fee
    f_count=0
    Adoption.all.each do |adoption|
      f_count += adoption.fee
    end
    f_count
  end
end