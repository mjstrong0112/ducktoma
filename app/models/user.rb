use_roles_strategy :role_strings

class User
  include Mongoid::Document
  include Roles::Mongoid
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  references_many :adoptions

  strategy :role_strings, :default

  roles :admin, :sales
end
