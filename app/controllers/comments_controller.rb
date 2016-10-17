class CommentsController < ApplicationController

  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      flash[:success] = "Comment posted!"
      redirect_to posts_path
    else
      flash[:danger] = "Something went wrong!"
      redirect_to posts_path
    end
  end

  private
  
    def comment_params
      params.require(:comment).permit(:post_id, :body)
    end
end
