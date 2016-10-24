require 'test_helper'

class FriendRequestIntegTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end

  def setup
    @frank = users(:frank)
    @mike = users(:mike)
  end

  test "friend request creation and approval" do
    sign_in @frank
    get user_path(@mike)
    assert_select "input[type=submit][value=Friend]"
    post friend_requests_path, params: {friend_request: {user_id: @frank.id, friend_id: @mike.id} }
    assert_redirected_to user_path(@mike)
    request = FriendRequest.last
    assert_equal request.user_id, @frank.id
    assert_equal request.friend_id, @mike.id
    sign_out @frank

    #joe gets request
    sign_in @mike
    get root_path
    assert_select "button[id=dropdownMenu1]" do 
      assert_select "span[class=badge]", "1"
    end
    assert_select "input[type=submit][value=Approve]"
    assert_select "a[href=?]", "/friend_requests/#{request.id}"
    post approve_friend_request_path(request)
    assert_redirected_to user_path(@frank)
    request.reload
    assert request.approved
    recip_request = FriendRequest.last
    assert_equal recip_request.user_id, @mike.id
    assert_equal recip_request.friend_id, @frank.id
    assert recip_request.approved
  end
end
