require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end

  def setup
    @frank = users(:frank)
    @sam = users(:sam)
    @profile_image = 'test/fixtures/profile_image.jpg'
  end

  #unverified user should be redirected from edit profile
  test "unverified user is redirected from edit profile" do
    file = Rack::Test::UploadedFile.new(@profile_image, "image/jpg")
    get edit_user_path(@frank)
    assert_redirected_to new_user_session_path
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
    patch profile_path(@frank), params: {profile: {picture: file} }
    assert_nil @frank.profile
    assert_redirected_to new_user_session_path
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
  end

  #verified user can upload picture and show view displays it
  test "verified user can upload profile picture" do
    assert_nil @frank.profile
    file = Rack::Test::UploadedFile.new(@profile_image, "image/jpg")
    sign_in @frank
    get edit_user_path(@frank)
    assert_response :success
    patch profile_path, params: {profile: {picture: file} }
    @frank.reload
    assert @frank.profile.picture.path
    assert_redirected_to user_path(@frank)
    follow_redirect!
    assert_select "img[src=?]", @frank.profile.picture.url
  end

  #show user view displays user info
  test "user profile shows user info" do
    sign_in @sam
    get user_path(@frank)
    assert_select "h1", @frank.email
    assert_select "img[src=?]", 'http://placehold.it/150x150'
  end
end
