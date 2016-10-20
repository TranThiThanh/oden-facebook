require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end

  def setup
    @frank = users(:frank)
    @joe = users(:joe)
  end

  #test login
  test "user should see nav links when logged in" do
    get root_path
    assert_redirected_to new_user_session_path
    sign_in users(:frank)
    get root_path
    assert_select "a[href=?]", new_user_session_path, count: 0
    assert_select "a[href=?]", destroy_user_session_path
    assert_select "a[href=?]", user_path(users(:frank))
  end

  #unverified user cannot see user profile
  test "unverified user should be redirected from user profile" do
    get user_path(@joe)
    assert_redirected_to new_user_session_path
  end

  #verified user can view user profile
  test "verified user can view user profile" do
    sign_in @frank
    get user_path(@joe)
    assert_select "h1", "joe@test.com"
  end

  #unverified user cannot access user edit page
  test "unverified user cannot access user edit page" do
    get edit_user_path(@joe)
    assert_redirected_to new_user_session_path
  end

  #wrong user gets redirected from user edit page
  test "wrong user cannot edit profile" do
    sign_in @frank
    get edit_user_path(@joe)
    assert_redirected_to root_path
    assert_equal "You don't have permission to do that!", flash[:danger]
  end

  #correct user can access user edit page
  test "correct user can access edit user page" do
    sign_in @frank
    get edit_user_path(@frank)
    assert_select "h3", "Edit Photo"
  end
end
