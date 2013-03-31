module AdoptionsHelper

  def total_duck_count
    Adoption.paid.joins(:ducks).count
  end

  def total_fee
    Adoption.paid.sum(&:fee)
  end

  def pricing_json
    Pricing.order('quantity desc').map {|p| {:quantity => p.quantity, :price => p.price}}.to_json
  end

  def contact_info_item(contact_info, field)
    unless contact_info[field].blank?
      raw (
        content_tag(:p, field.to_s.titleize + ":") +
        content_tag(:p, contact_info[field]) +
        content_tag(:br)
      )
    else
      nil
    end
  end

end