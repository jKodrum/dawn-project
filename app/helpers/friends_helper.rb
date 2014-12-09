module FriendsHelper
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
end
