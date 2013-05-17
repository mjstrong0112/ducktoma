class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :role

  # == associations ==
  has_many :adoptions
  has_many :sales_events, :through => :adoptions

  sortable :email, 'asc'


  def admin?
    role.to_s == "admin"
  end

  def sales?
    role.to_s == "sales"
  end

  def is? is_role
    return false if role.nil?
    # Admins automatically have all roles.
    return true if admin?
    return true if role.to_sym == is_role
  end

  def duck_count
    adoptions.joins(:ducks).select("SUM(ducks.id) as duck_count").sum(&:duck_count)
  end

  def fee
    adoptions.sum(&:fee)
  end

  def sales_adoptions
    adoptions_f :sales
  end

  def adoptions_f(type)
    unless type
      adoptions
    else
      adoptions.where(:sales_type => type)
    end
  end


end