require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "valid user signup" do
    get new_user_registration_path
    assert_difference 'User.count', 1 do
      post user_registration_path, params: {user: {
          email: "user@test.com", password: "password", password_confirmation: "password"
        } }
    end
    assert_equal User.last.email, "user@test.com"
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", destroy_user_session_path
  end
end
