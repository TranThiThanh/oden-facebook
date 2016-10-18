class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @friend_request = FriendRequest.new
  end

  def edit
    @user = User.find(params[:id])
    @profile = Profile.where(user_id: current_user.id).first_or_create
  end

end
