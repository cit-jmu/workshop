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
      can :cit_feed, Course

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
        can :view_enrollments, Section, instructor_id: @user.id
        # instructors can update sections they are teaching
        can :update, Section, instructor_id: @user.id
        # instructors can enroll people in sections they are teaching
        can :enroll_user, Section, instructor_id: @user.id
        # they can also drop folks
        can :drop_user, Section, instructor_id: @user.id
        # and mark folks as having completed a section
        can :mark_completed, Section, instructor_id: @user.id
      end
    end

    def user_permissions
      # users can see and edit themselves
      can :show, User, :id => @user.id
      can :update, User, :id => @user.id
    end
end
