module ApplicationHelper
  def render_login
    if !user_signed_in?
      link_to "登入", new_user_session_path, class: "btn btn-primary"
    else
      link_to "登出", destroy_user_session_path, class: "btn btn-warning", method: :delete
    end
  end
end
