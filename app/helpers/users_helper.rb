module UsersHelper
  def profile_field(form, helper, attribute)
    if can?(:update, @user) && !@user.in_ldap?
      form.send helper, attribute, :class => 'form-control'
    else
      form.send helper, attribute, :class => 'form-control',
                                   :disabled => true
    end
  end

  def profile_nav_link_to(name, path)
    css_class = 'list-group-item'
    css_class += ' active' if current_page?(path)
    link_to name, path, :class => css_class
  end
end
