class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    if user.admin?
      can :manage, :all
    else
      can :read, :all
      can :enroll, Section
      can :unenroll, Section
      can :view_enrollments, Section do |section|
        section.try(:user) == user || user.role?(:instructor)
      end
    end
  end
end