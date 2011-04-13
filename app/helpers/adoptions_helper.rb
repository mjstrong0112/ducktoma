module AdoptionsHelper
  def total_duck_count
    d_count=0
    Adoption.all.each do |adoption|
      d_count += adoption.duck_count unless(adoption.state == "pending")
    end
    d_count
  end
  def total_fee
    f_count=0
    Adoption.all.each do |adoption|
      f_count += adoption.fee unless(adoption.state == "pending")    
    end
    f_count
  end
  def pricing_json
    Pricing.desc(:quantity).map {|p| {:quantity => p.quantity, :price => p.price}}.to_json
  end
end