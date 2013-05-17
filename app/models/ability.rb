class Ability
  include CanCan::Ability
  def initialize(user)    
    can :create, Adoption
    can :show, Adoption, :user_id => nil
    can :edit, Adoption, :user_id => nil
    can :show, ClubMember

    user_abilities(user)        if user.class == User      
    club_member_abilities(user) if user.class == ClubMember
  end

  def user_abilities(user)
    if user
      can :read, Adoption, :user_id => user.id
      can :manage, User, :id => user.id
      can :manage, :all if user.admin?
    end
  end

  def club_member_abilities(club_member)
    can :manage, ClubMember, id: club_member.id
    if club_member.is?(:leader)
      can :manage, ClubMember, organization: { id: club_member.organization.id }
    end 
  end


end