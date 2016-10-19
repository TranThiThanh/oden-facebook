class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.new
    @posts = current_user.post_feed
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      flash[:success] = "Post create!"
      redirect_to posts_path
    else
      flash[:danger] = "Something went wrong!"
      redirect_to posts_path
    end
  end
  
  private

    def post_params
      params.require(:post).permit(:content)
    end
end
