require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end

  def setup
    @frank = users(:frank)
  end

  #unverified user is redirected
  test "unverified user is redirected from user index" do
    get users_path
    assert_redirected_to new_user_session_path
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
  end

  #verified user sees users and friend request buttons
  test "verified user sees users and friend button" do
    sign_in(@frank)
    get users_path
    assert_response :success
    assert_select "div[id=?]", "user_#{@frank.id}" do
      assert_select "input[type=submit]", count: 0
    end
    assert_select "div[id=?]", "user_#{users(:joe).id}" do
      assert_select "input[type=submit][value=Friend][disabled=disabled]"
    end
    assert_select "div[id=?]", "user_#{users(:sam).id}" do
      assert_select "input[type=submit][value=Friend][disabled=disabled]"
    end
    assert_select "div[id=?]", "user_#{users(:mike).id}" do
      assert_select "input[type=submit][value=Friend]"
      assert_select "input[type=submit][value=Friend][disabled=disabled]", count: 0
    end
  end
 
end
