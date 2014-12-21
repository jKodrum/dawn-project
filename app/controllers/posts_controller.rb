class PostsController < ApplicationController
  before_action :find_user, except: [:index]
  def index
    @posts = Post.all.recent
  end

  def show
    @post = @user.posts.find(params[:id])
    @comment = @post.comments.new
  end

  def edit
    @post = @user.posts.find(params[:id])
  end

  def update
    @post = @user.posts.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "成功修改文章"
    else
      m = "文章修改失敗，"
      @post.errors.messages.each do |e|
        m << e.join(", ") << " "
      end
      flash[:alert] = m
    end
    redirect_to user_profile_path(@user.name, @user.id)
  end

  def create
    @post = @user.posts.new(post_params)
    if @post.save
      flash[:notice] = "成功發佈文章"
    else
      m = "文章發佈失敗，"
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
    flash[:warning] = "文章已成功刪除"
    redirect_to user_profile_path(@user.name, @user.id)
  end

  private
  def post_params
    params.require(:post).permit(:title, :content)
  end

  def find_user
    @user = User.find(params[:user_id]) 
  end
end
