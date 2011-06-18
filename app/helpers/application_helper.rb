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
    sales_events = SalesEvent.where(:organization => organization).only(:id).map(&:id)
    Adoption.where(:sales_event_id.in => sales_events).sum(:fee)
  end
  def find_total_ducks_by_organization(organization)
    sales_events = SalesEvent.where(:organization => organization).only(:id).map(&:id)
    adoption_ids = Adoption.where(:sales_event_id.in => sales_events).only(:id).map(&:id)
    Duck.where(:adoption_id.in => adoption_ids).count
  end

  def duplicates(enum)
    enum.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.select { |k,v| v > 1 }.collect { |x| x.first }
  end  
end
