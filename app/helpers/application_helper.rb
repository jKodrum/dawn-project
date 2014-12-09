module ApplicationHelper
  def user_tag
    if user_signed_in?
      link_to current_user.name, user_profile_path(current_user.name, current_user.id)
    end
  end

  def login_tag
    if !user_signed_in?
      link_to "登入", new_user_session_path
    else
      link_to "登出", destroy_user_session_path, method: :delete
    end
  end

  def notice_tag
    if flash[:notice]
      "提示: " << flash[:notice]
    end
  end

  def alert_tag
    if flash[:alert]
      "注意: " << flash[:alert]
    end
  end

end
