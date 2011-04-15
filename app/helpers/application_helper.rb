module ApplicationHelper
  def dollar_fee(fee)
    BigDecimal.new(fee.to_s)/100
  end
  def retrieve_pricing_scheme(pricing)
    pricings = Pricing.desc(:quantity).to_a
    pricing = pricings.detect do |p|
     pricing >= (p.quantity+1)*p.price
    end
    pricing ||= pricings.last
    return pricing
  end
  #if the value is null or blank, it will display null or blank as a string
  def null_literal(value)
    if value
      if value.blank?
        "blank"
      elsif !value.blank?
        value
      end
    else
      "null"
    end
  end

  def find_total_fee_by_organization(organization)
    total_fee = 0
    adoptions = []
    sales_events = SalesEvent.where(:organization => organization)
    sales_events.each{|sales_event| adoptions += sales_event.adoptions.to_a.flatten }
    adoptions.each{|adoption| total_fee += adoption.fee }
    total_fee
  end
  def find_total_ducks_by_organization(organization)
    total_ducks = 0
    adoptions = []
    sales_events = SalesEvent.where(:organization => organization)
    sales_events.each{|sales_event| adoptions += sales_event.adoptions.to_a.flatten }
    adoptions.each{|adoption| total_ducks += adoption.duck_count }
    total_ducks    
  end
end
