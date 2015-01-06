class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @author = current_user
    @comment = @post.comments.new(comment_params)
    @comment.commenter = @author
    if @comment.save
    else
      flash[:warning] = "留言錯誤"
    end
    redirect_to :back
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to :back
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
