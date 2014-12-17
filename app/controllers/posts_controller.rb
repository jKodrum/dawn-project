class PostsController < ApplicationController
  before_action :find_user, except: [:index]
  def index
    @posts = Post.all.recent
  end

  def edit
    @post = @user.posts.find(params[:id])
  end

  def update
    redirect_to :back
  end

  def create
    @post = @user.posts.new(post_params)
    if @post.save
      flash[:notice] = "成功發佈文章"
    else
      m = ""
      @post.errors.messages.each do |e|
        m << e.join(", ") << " "
      end
      flash[:alert] = m
    end
    redirect_to user_profile_path(@user.name, @user.id)
  end

  def destroy
    @post = @user.posts.find(params[:id])
    @post.destroy
    redirect_to user_profile_path(@user.name, @user.id)
  end

  private
  def post_params
    params.require(:post).permit(:title, :content)
  end

  def find_user
    @user = User.find_by_name(params[:user_name]) 
  end
end
