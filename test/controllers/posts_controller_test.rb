require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @post = Post.new(content: "This is a test post")
  end

  #test no sign in redirected to login
  test "unverified user should be redirected to login" do
    get posts_path
    assert_redirected_to new_user_session_path
  end

  test "unverified user cannot create post" do
    assert_no_difference 'Post.count' do
      post posts_path, params: {post: {content: @post.content} }
    end
    assert_redirected_to new_user_session_path
  end

  test "verified user can create a post" do
    sign_in users(:frank)
    assert_difference 'Post.count', 1 do
      post posts_path, params: {post: {content: @post.content} }
    end
    assert_redirected_to posts_path
    follow_redirect!
    assert_match @post.content, response.body
  end
end
