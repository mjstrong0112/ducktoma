Fabricator(:user) do
  email { Forgery::Internet.email_address }
  password { Forgery::Basic.password :allow_special => true }
  adoptions(:count => (1..6).to_a.sample) { |user| Fabricate(:adoption, :user => user) }
end

Fabricator(:admin, :from => :user) do
  email { Forgery::Internet.email_address }
  password { Forgery::Basic.password :allow_special => true }
  roles [:admin]
end

Fabricator(:pricing) do
  quantity { Forgery::Basic.number(:at_least => 1, :at_most => 300) }
  price { Forgery::Basic.number(:at_least => 1, :at_most => 300) }
end

Fabricator(:sales_user, :from => :user) do
  email { Forgery::Internet.email_address }
  password { Forgery::Basic.password :allow_special => true }
  roles [:sales]
end

Fabricator(:adoption) do
  adoption_number { Forgery::Basic::UPPER_ALPHA.random_subset(1).join + Forgery::Basic.number(:at_least=> 100000, :at_most => 999999).to_s }
  duck_count { (1..10).to_a.sample }  
end

Fabricator(:sales_adoption, :from => :adoption) do
  type :sales
  fee { |adoption| adoption.calculate_fee }
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