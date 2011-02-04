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

  def duck_count
    d_count = 0
    adoptions.all.each do |adoption|
      d_count += adoption.duck_count
    end
    d_count
  end

  def fee
    f_count = 0
    adoptions.all.each do |adoption|
      f_count += adoption.fee
    end
    f_count
  end

  def adoptions_f(type)
    unless type
      adoptions
    else
      adoptions.where(:type => type)
    end
  end

  def sales_adoptions
    adoptions_f :sales
  end

  def sales_events
    SalesEvent.find(adoptions.map{|a| a.sales_event_id})
  end
end