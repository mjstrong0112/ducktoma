require 'spec_helper'

describe Location do
  should_have_field :name
  should_validate_presence_of :name
end
