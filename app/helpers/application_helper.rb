module ApplicationHelper
  def welcome_div
    content = ""
    if current_user
      content << link_to("My Lists", user_lists_url(current_user))
      content << " &middot; "
      content << "Welcome #{h(current_user.email)}.  "
      content << link_to("Log Out", destroy_user_session_url)
    else
      content << link_to("Sign In", new_user_session_url)
    end
    content_tag(:div, content.html_safe, :class => 'welcome')
  end
end
