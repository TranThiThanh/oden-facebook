class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @friend_request = FriendRequest.new
  end

  def edit
    @user = User.find(params[:id])
    if current_user.id != @user.id
      flash[:danger] = "You don't have permission to do that!"
      redirect_to root_path
    else
      @profile = Profile.where(user_id: current_user.id).first_or_create
    end
  end

end
