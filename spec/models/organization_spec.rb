require 'spec_helper'

describe Organization do
  should_have_field :name
  should_validate_presence_of :name
end
