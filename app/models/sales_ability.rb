class SalesAbility
  include CanCan::Ability
  def initialize(user)
    if user
      can :manage, :all if user.admin? || user.is?(:sales)
    end    
  end
end