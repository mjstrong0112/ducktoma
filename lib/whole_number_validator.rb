class WholeNumberValidator < ActiveModel::EachValidator
  def validate_each(object,attribute,value)
    unless value.to_i == value
      object.errors[attribute] << (options[:message] || "has to be a whole number")
    end
  end
end