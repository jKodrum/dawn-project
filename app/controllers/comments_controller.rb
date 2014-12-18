class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @author = @post.author
    @comment = @post.comments.new
    @comment.commenter = @author
    if @comment.save
      flash[:notice] = "成功"
    else
      flash[:warning] = "留言錯誤"
    end
    redirect_to :back
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end