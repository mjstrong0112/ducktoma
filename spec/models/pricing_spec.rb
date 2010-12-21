require 'spec_helper'

describe Pricing do
  should_have_field :price, :type => Integer
  should_have_field :quantity, :type => Integer
end
