require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @frank = users(:frank)
    @profile_image = 'test/fixtures/profile_image.jpg'
  end

  #unverified user should be redirected from update profile
  test "unverified user is redirected from update profile" do
    assert_not @frank.profile
    file = Rack::Test::UploadedFile.new(@profile_image, "image/jpg")
    patch profile_path(@frank), params: {profile: {picture: file} }
    assert_redirected_to new_user_session_path
    @frank.reload
    assert_not @frank.profile
  end

  #wrong user should be redirected from update profile
  test "wrong user is redirected from update profile" do
    @joe = users(:joe)
    @joe_profile = Profile.where(user_id: @joe.id).first_or_create
    file = Rack::Test::UploadedFile.new(@profile_image, "image/jpg")
    assert_not @frank.profile
    sign_in @joe
    patch profile_path(@frank), params: {profile: {picture: file} }
    assert @joe.profile
    @frank.reload
    assert_not @frank.profile
  end

  #correct user can update profile image
  test "correct user can update profile image" do
    sign_in @frank
    assert_not @frank.profile
    get edit_user_path(@frank)
    @frank.reload
    assert @frank.profile
    assert_nil @frank.profile.picture.path
    file = Rack::Test::UploadedFile.new(@profile_image, "image/jpg")
    patch profile_path, params: {profile: {picture: file} }
    @frank.profile.reload
    assert @frank.profile.picture
    assert_not_nil @frank.profile.picture.path
  end
end
