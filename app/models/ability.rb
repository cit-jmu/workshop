class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    if user.admin?
      can :manage, :all
    else
      cannot :index, User
      can :show, User, id: user.id
      can :read, Section
      can :read, Course
      can :enroll, Section
      can :drop, Section
      can :view_enrollments, Section do |section|
        section.try(:user) == user || user.role?(:instructor)
      end
    end
  end
end