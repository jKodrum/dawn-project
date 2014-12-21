module ApplicationHelper
  def nav_user_tag
    if user_signed_in?
      nav_link_to current_user.name, user_profile_path(current_user.name, current_user.id), path_controller: "users"
    end
  end

  def user_tag
    if user_signed_in?
      link_to current_user.name, user_profile_path(current_user.name, current_user.id)
    end
  end

  def signup_tag
    if !user_signed_in?
      content_tag(:li) do
        link_to "註冊", new_user_registration_path
      end
    end
  end

  def login_tag
    if !user_signed_in?
      content_tag(:li) do
        link_to "登入", new_user_session_path
      end
    end
  end

  def current_user_image_tag
    if user_signed_in?
      link_to image_tag(current_user.image, size: "50"), user_profile_path(current_user.name, current_user.id), style: "padding: 0 15px"
    end
  end

  def link_user_image_tag(user)
    if user.provider
      link_to image_tag(user.image), user_profile_path(user.name, user.id), style: "padding: 0"
    end
  end

  def flash_tag
    if flash[:alert]
      f(message: '警告： ' << flash[:alert], class: "alert-danger")
    elsif flash[:warning]
      f(message: '注意： ' << flash[:warning], class: "alert-warning")
    elsif flash[:notice]
      f(message: '提示： ' << flash[:notice], class: "alert-info")
    elsif flash[:success]
      f(message: '成功： ' << flash[:success], class: "alert-success")
    end
  end

  def alert_tag
    if flash[:alert]
      "注意: " << flash[:alert]
    end
  end

  def friend_btn_tag(user)
    if user_signed_in? && current_user != user 
      if !current_user.has_relation_of?(user) 
        link_to request_friend_path(user.name, user.id), class: "btn btn-primary", method: :post do
          @icon = %(<i class="glyphicon glyphicon-user"></i> 加為好友).html_safe
        end
      elsif current_user.has_sent_request_to?(user)
        link_to cancel_request_path(user.name, user.id), class: "btn btn-warning", method: :post do
          @icon = %(<i class="glyphicon glyphicon-remove"></i> 收回好友邀請).html_safe
        end
      elsif current_user.has_got_request_from?(user)
        link_to accept_friend_path(user.name, user.id), class: "btn btn-success", method: :post do
          @icon = %(<i class="glyphicon glyphicon-ok"></i> 接受好友邀請).html_safe
        end
      elsif current_user.is_friend_of?(user)
        link_to remove_friend_path(user.name, user.id), class: "btn btn-danger", method: :post do
          @icon = %(<i class="glyphicon glyphicon-trash"></i> 刪除好友).html_safe
        end
      end
    end 
  end

  def nav_link_to(link_text, link_path, options={}) 
    default_options = {
      class: nil,
      icon: nil,
      path_controller: params[:controller]
    }
    options = default_options.merge(options)
    if_active = params[:controller]==options[:path_controller] ? "active" : ""
    options[:class] = if_active << " " << options[:class].to_s
    options[:icon] &&= "glyphicon glyphicon-#{options[:icon]}"
     
    content_tag(:li, class: options[:class]) do
      link_to link_path, class: "navbar-brand" do
        content_tag(:span, nil, class: options[:icon]) << ' ' <<link_text
      end
    end
  end
end
