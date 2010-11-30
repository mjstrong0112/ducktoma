Fabricator(:user) do
  email Forgery::Internet.email_address
  password Forgery::Basic.password :allow_special => true
  adoptions(:count => (1..6).to_a.sample) { |user| Fabricate(:adoption, :user => user) }
end
#Fabricator(:admin, :from => :user) do
#  # Admin stuff here
#end
Fabricator(:adoption) do
  raffle_number { Forgery::Basic::UPPER_ALPHA.random_subset(1).join + Forgery::Basic.number(:at_least=> 100000, :at_most => 999999).to_s }
  duck_count { (1..10).to_a.sample }
  fee Forgery::Basic.number(:at_least => 100, :at_most => 8000000)
end

Fabricator(:duck) do
  number Forgery::Basic.number(:at_least => 1, :at_most => 10000)
end