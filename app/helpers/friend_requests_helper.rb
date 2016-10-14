module FriendRequestsHelper

  def already_friends(user)
    if FriendRequest.where(user_id: current_user.id, friend_id: user.id).any?
      return true
    else
      return false
    end
  end
end
