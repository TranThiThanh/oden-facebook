class FriendRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    @friend_request = FriendRequest.new(friend_request_params)
    @friend_request.approved = false
    if @friend_request.save
      flash[:success] = "Friend request sent!"
      redirect_to user_path(@friend_request.friend_id)
    else

    end
  end

  def approve
    @request = FriendRequest.find(params[:id])
    @request.approved = true
    if @request.save
      @recip = FriendRequest.new(user_id: current_user.id, friend_id: @request.user_id, approved: true)
      @recip.save
      flash[:success] = "Friend Request Approved!"
      redirect_to user_path(@request.user_id)
    else
      flash[:danger] = "Something went wrong!"
      redirect_to root_path
    end
  end

  def destroy
    @request = FriendRequest.find(params[:id])
    
    if current_user.id != @request.friend_id
      flash[:danger] = "You don't have permission to do that!"
      redirect_to root_path
    else
      if @request.destroy
        flash[:success] = "Delete!"
        redirect_to root_path
      else
        flash[:danger] = "Something went wrong!"
        redirect_to root_path
      end
    end
  end

  private
    def friend_request_params
      params.require(:friend_request).permit(:user_id, :friend_id)
    end
end
