module ApplicationHelper
  def login_tag
    if !user_signed_in?
      link_to "登入", new_user_session_path
    else
      link_to "登出", destroy_user_session_path
    end
  end
end
