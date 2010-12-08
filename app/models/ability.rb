class Ability
  include CanCan::Ability
  def initialize(user)    
    can :create, Adoption
    if user
      can :read, :all
      can :manage, :all if user.admin?      
    end
  end
end