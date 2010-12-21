class SalesAbility
  include CanCan::Ability
  def initialize(user)
    if user
      can :manage, Adoption if user.is?(:sales)
      can :manage, :all if user.admin?
    end    
  end
end