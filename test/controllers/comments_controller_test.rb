require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end

  def setup
    @frank = users(:frank)
    @post = posts(:first_post)
  end

  #validate unverified user cannot create comment
  test "unverified user should be redirected from create comment" do
    comment = "this is a comment"
    assert_no_difference 'Comment.count' do
      post comments_path, params: {comment: {post_id: @post.id, content: comment} }
    end
    assert_redirected_to new_user_session_path
  end

  #validate verified user can post comment
  test "valid user can create comment" do
    comment = "this is a comment"
    sign_in users(:frank)
    assert_difference 'Comment.count', 1 do
      post comments_path, params: {comment: {post_id: @post.id, content: comment} }
    end
    assert_redirected_to posts_path
  end
end
