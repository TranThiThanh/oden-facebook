class CommentsController < ApplicationController

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = params[:post_id]
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
      params.require(:comment).permit(:body)
    end
end
