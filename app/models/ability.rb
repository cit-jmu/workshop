class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new

    if @user.admin?
      # admins get all the superpowers
      can :manage, :all
    else
      course_permissions
      section_permissions
      user_permissions
    end
  end

  private
    def course_permissions
      # everyone can see courses
      can :read, Course

      if @user.instructor?
        # instructors can update courses they are teaching
        can :update, Course, sections: { instructor_id: @user.id }
      end
    end

    def section_permissions
      # everyone can see sections and enroll/drop
      can :read, Section
      can :enroll, Section
      can :drop, Section

      if @user.instructor?
        # instructors can view rosters for sections they are teaching
        can :roster, Section, instructor_id: @user.id
      end
    end

    def user_permissions
      # users can see themselves
      can :show, User, id: @user.id
    end
end
