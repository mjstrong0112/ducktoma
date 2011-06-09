class Ability
  include CanCan::Ability
  def initialize(user)    
    can :create, Adoption
    can :show, Adoption, :user_id => nil
    can :edit, Adoption, :user_id => nil
    if user
      can :read, Adoption, :user_id => user.id
      can :manage, :all if user.admin?
    end
  end
end