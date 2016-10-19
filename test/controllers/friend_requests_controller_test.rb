require 'test_helper'

class FriendRequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end

  def setup
    @frank = users(:frank)
    @joe = users(:joe)
    @request = friend_requests(:to_joe)
  end

  #validate unverified user cannot create friend request
  test "unverified user is redirected from friend request" do
    assert_no_difference 'FriendRequest.count' do
      post friend_requests_path, params: {friend_request: {
          user_id: @frank.id, friend_id: @joe.id
        } }
    end
    assert_redirected_to new_user_session_path
  end

  #verified user can create friend request
  test "verified user can send friend request" do
    sign_in users(:frank)
    assert_difference 'FriendRequest.count', 1 do
      post friend_requests_path, params: {friend_request: {
          user_id: @frank.id, friend_id: @joe.id
        } }
    end
    assert_redirected_to user_path(@joe)
  end

  #unverified user cannot approve friend request
  test "unverified user should not approve friend request" do
    assert_not friend_requests(:to_joe).approved
    post approve_friend_request_path(@request)
    assert_redirected_to new_user_session_path
    assert_not friend_requests(:to_joe).approved
  end

  #verified user can approve friend request
  test "verified user can approve friend request" do
    assert_not friend_requests(:to_joe).approved
    sign_in users(:joe)
    #test recip request is created
    assert_difference 'FriendRequest.count', 1 do
      post approve_friend_request_path(@request)
    end
    assert_redirected_to user_path(@frank)
    friend_requests(:to_joe).reload
    assert friend_requests(:to_joe).approved
  end

  #unverified user cannot delete friend request
  test "unverified user cannot delete friend request" do
    assert_no_difference 'FriendRequest.count' do
      delete friend_request_path(@request)
    end
    assert_redirected_to new_user_session_path
  end

  #wrong user cannot delete friend request
  test "wrong user cannot delete friend request" do
    sign_in users(:nofriend)
    assert_no_difference 'FriendRequest.count' do
      delete friend_request_path(@request)
    end
    assert_redirected_to root_path
  end
  
  #correct user can delete friend request
  test "correct user can delete friend request" do
    sign_in users(:joe)
    assert_difference 'FriendRequest.count', -1 do
      delete friend_request_path(@request)
    end
    assert_redirected_to root_path
  end
end
