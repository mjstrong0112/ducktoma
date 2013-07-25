Fabricator(:user) do
  email { Forgery::Internet.email_address }
  password { Forgery::Basic.password :allow_special => true, :at_least => 8 }
  adoptions(:count => (1..6).to_a.sample) { |user| Fabricate(:adoption) }
end

Fabricator(:admin, :from => :user) do
  email { Forgery::Internet.email_address }
  password { Forgery::Basic.password :allow_special => true, :at_least => 8 }
  role :admin
end

Fabricator(:pricing) do
  quantity { Forgery::Basic.number(:at_least => 1, :at_most => 300) }
  price { Forgery::Basic.number(:at_least => 1, :at_most => 300) }
end

Fabricator(:sales_user, :from => :user) do
  email { Forgery::Internet.email_address }
  password { Forgery::Basic.password :allow_special => true, :at_least => 8 }
  role :sales
end

Fabricator(:adoption) do
  number { Forgery::Basic::UPPER_ALPHA.random_subset(1).join + Forgery::Basic.number(:at_least=> 100000, :at_most => 999999).to_s }
  duck_count { (1..10).to_a.sample }
end

Fabricator(:sales_adoption, :from => :adoption) do
  sales_type :sales
  fee { |a| Adoption.new(a).calculate_fee }
end

Fabricator(:duck) do
  number { Forgery::Basic.number(:at_least => 1, :at_most => 10000) }
end

Fabricator(:location) do
  name { Forgery::Address.state }
end
Fabricator(:organization) do
  name { Forgery::Name.company_name }
end

Fabricator(:sales_event) do
  date { Date.today }
  organization
  location
end

Fabricator(:club_member) do
  name { Forgery::Name.full_name }
  password { Forgery::Basic.password :allow_special => true, :at_least => 8 }
  organization
end