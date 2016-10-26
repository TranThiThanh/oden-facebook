require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @frank = users(:frank)
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
end
