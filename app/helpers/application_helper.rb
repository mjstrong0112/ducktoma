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
end
