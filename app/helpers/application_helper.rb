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

  # TODO: Verify with uncle mike that these functions should only consider sales events.
  def find_total_fee_by_organization(organization)
    (
      Adoption.valid.joins(:sales_event => :organization).where('organizations.id = ?', organization.id).sum(:fee) +
      Adoption.valid.where(club_id: organization).sum(&:fee)
    )
  end

  def find_total_ducks_by_organization(organization)
    (
      # TODO: Reform "invalid" query to use scope.
      Duck.joins(:adoption => {:sales_event => :organization})
          .where('organizations.id = ?', organization.id)
          .where("adoptions.state != 'invalid'")
          .count +    
      Duck.joins(:adoption).where("adoptions.club_id = ?", organization.id).where("adoptions.state != 'invalid'").count
    )
  end

  def duplicates(enum)
    enum.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.select { |k,v| v > 1 }.collect { |x| x.first }
  end

end
