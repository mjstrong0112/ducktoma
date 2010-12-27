module ApplicationHelper
  def dollar_fee(fee)
    BigDecimal.new(fee.to_s)/100
  end
end
