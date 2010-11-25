class Duck
  include Mongoid::Document

  field :number, :type => Integer

  referenced_in :adoption
end