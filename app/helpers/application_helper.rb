module ApplicationHelper

  def organization_avatar organization
    url = organization.try(:avatar).try(:url)
    return if url.nil?
    image_tag url
  end

  def dollar_fee(fee)
    BigDecimal.new(fee.to_s)/100
  end

  def retrieve_pricing_scheme(pricing)
    pricings = Pricing.order("quantity desc").to_a
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
    (
      Adoption.paid.includes(:sales_event => :organization)
              .where('organizations.id = ? OR adoptions.club_id = ?', organization.id, organization.id)
              .sum(:fee)
    )
  end

  def find_total_ducks_by_organization(organization)
    (
      Duck.paid.includes(:adoption => {:sales_event => :organization})
          .where('organizations.id = ? OR adoptions.club_id = ?', organization.id, organization.id)
          .count
    )
  end

  def duplicates(enum)
    enum.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.select { |k,v| v > 1 }.collect { |x| x.first }
  end

end
