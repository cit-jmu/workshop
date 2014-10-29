module UsersHelper
  def profile_field(form, helper, attribute, options = {})
    options = options.reverse_merge(:class => '')
    # add the bootstrap 'form-control' class
    options[:class] += ' form-control'
    # disable input unless the current user can :update this user and this
    # user is not managed through LDAP
    options[:disabled] = true unless can?(:update, @user) && !@user.in_ldap?
    # pass this along to the form
    form.send helper, attribute, options
  end

  def error_class?(attribute)
    'has-error' if @user.errors[attribute].any?
  end

  def profile_nav_link_to(name, path)
    css_class = 'list-group-item'
    css_class += ' active' if current_page?(path)
    link_to name, path, :class => css_class
  end
end
