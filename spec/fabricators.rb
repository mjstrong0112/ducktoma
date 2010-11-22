Fabricator(:user) do
  email Forgery::Internet.email_address
  password Forgery::Basic.password :allow_special => true
end
#Fabricator(:admin, :from => :user) do
#  # Admin stuff here
#end