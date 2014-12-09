class FriendsController < ApplicationController
  def index
    @user = User.find_by_name(params[:user_name])
    @friends = @user.friends
  end
end
