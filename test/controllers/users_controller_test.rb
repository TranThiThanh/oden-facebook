require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end

  #test login
  test "user should see nav links when logged in" do
    get root_path
    assert_redirected_to new_user_session_path
  end
end
