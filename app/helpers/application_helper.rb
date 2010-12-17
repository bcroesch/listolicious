module ApplicationHelper
  def welcome_div
    content_tag(:div, :class => 'welcome') do
      if current_user
        concat("Welcome "+current_user.email+".  ")
        concat(link_to "Log Out", destroy_user_session_url)
      else
        concat(link_to "Sign In", new_user_session_url)
        concat(" or ")
        concat(link_to "Sign Up", new_user_registration_url)
      end
    end
  end
end
