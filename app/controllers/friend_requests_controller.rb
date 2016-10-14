class FriendRequestsController < ApplicationController

  def create
    @friend_request = FriendRequest.new(friend_request_params)
    @friend_request.approved = false
    if @friend_request.save
      flash[:success] = "Friend request sent!"
      redirect_to user_path(@friend_request.friend_id)
    else

    end
  end

  private
    def friend_request_params
      params.require(:friend_request).permit(:user_id, :friend_id)
    end
end