module AdoptionsHelper
  def total_duck_count
    d_count=0
    Adoption.paid.each { |adoption| d_count += adoption.duck_count }
    d_count
  end
  def total_fee
    f_count=0
    Adoption.paid.each { |adoption| f_count += adoption.fee }
    f_count
  end
  def pricing_json
    Pricing.desc(:quantity).map {|p| {:quantity => p.quantity, :price => p.price}}.to_json
  end
end