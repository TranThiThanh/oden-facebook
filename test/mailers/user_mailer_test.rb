require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "welcome_email" do
    mail = UserMailer.welcome_email(users(:frank))
    assert_equal "Welcome to my Facebook clone", mail.subject
    assert_equal [users(:frank).email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
