class AdminAbility
  include CanCan::Ability
  def initialize(user)
    if user
      can :manage, :all if user.admin?      
    end
  end
end