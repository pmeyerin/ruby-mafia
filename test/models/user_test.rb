require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "email_address must be unique" do
    user = users(:one)
    another_user = User.new(user_name: "another_user", email_address: user.email_address, password: "password")
    assert_not another_user.valid?
    assert_equal [ "Email address has already been taken" ], another_user.errors.full_messages
  end
  test "multiple null email addresses allowed" do
    another_user = User.new(user_name: "another_user", password: "password", email_address: nil)
    assert another_user.valid?
    yet_another_user = User.new(user_name: "yet_another_user", password: "password", email_address: nil)
    assert yet_another_user.valid?
  end
end
