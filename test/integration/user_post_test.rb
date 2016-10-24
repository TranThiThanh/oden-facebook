require 'test_helper'

class UserPostTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # test "the truth" do
  #   assert true
  # end

  def setup
    @frank = users(:frank)
  end

  #unverified user can't post
  test "unverified user is redirected" do
    get posts_path
    assert_redirected_to new_user_session_path
  end

  #verified user can post
  test "verified user can post" do
    sign_in @frank
    get posts_path
    assert_select "textarea[name='post[content]']"
    post posts_path, params: {post: {content: "This is my post"} }
    assert_redirected_to posts_path
    follow_redirect!
    user_post = @frank.posts.last
    assert_select "div#post_#{user_post.id}" do
      assert_select "a[href=?]", user_path(@frank)
      assert_select "p", "This is my post"
    end
  end

end
