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
end
