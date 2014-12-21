class UsersController < ApplicationController
  before_action :find_user, except: :index
  def index
    unless current_user.try(:admin)
      redirect_to :root
    end
    @users = User.where.not(id: current_user)
  end

  def show
    @post = @user.posts.build
    # give it a where-condition to avoid empty item generated
    # by ".build" or ".new" when looping
    @posts = @user.posts.where("id >= 0").recent
  end

  def destroy
    @user.destroy
    redirect_to :back
  end

  def request_friend
    if !current_user.has_relation_of?(@user)
      current_user.sends_request_to(@user)
      flash[:success] = "送出好友邀請給#{@user.name}"
    end
    # redirect back
    # redirect_to :back, notice: "Notice..."
    redirect_to(request.env['HTTP_REFERER'])
  end

  def cancel_request
    if current_user.has_sent_request_to?(@user)
      current_user.cancels_request_from(@user)
      flash[:warning] = "收回對#{@user.name}的好友邀請"
    elsif current_user.is_friend_of?(@user)
      flash[:warning] = "已經是好友"
    else
      flash[:alert] = "好友邀請已撤銷"
    end
    # redirect back
    redirect_to(request.env['HTTP_REFERER'])
  end

  def accept_friend
    if current_user.has_got_request_from?(@user)
      current_user.accepts_friend(@user)
      flash[:success] = "加#{@user.name}為好友"
    else
      flash[:alert] = "好友邀請已被取消"
    end
    # redirect back
    redirect_to(request.env['HTTP_REFERER'])
  end

  def remove_friend
    if current_user.is_friend_of?(@user)
      current_user.removes_friend(@user)
      flash[:notice] = "和#{@user.name}不是好友"
    else
      flash[:alert] = "早已不是好友"
    end
    # redirect back
    redirect_to(request.env['HTTP_REFERER'])
  end

  private
  def find_user
    @user = User.find(params[:user_id])
    @user ||= User.find_by_name(params[:user_name])
    unless @user
      render status: 404, 
        text: "dawnbank Notice: " << params[:user_name] << " not found."
    end
  end

end
