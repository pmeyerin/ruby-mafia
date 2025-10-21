require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "register new user" do
    assert_difference "User.count", 1 do
      post registration_url, params: { user: { email_address: "test@example.com", password: "password", user_name: "test" } }
    end
  end
  test "nullable email" do
    assert_difference "User.count", 1 do
      post registration_url, params: { user: { email_address: nil, password: "password", user_name: "test" } }
    end
  end
  test "duplicate user fails" do
    assert_difference "User.count", 0 do
      post registration_url, params: { user: { email_address: "one@example.com", password: "password", user_name: users(:one).user_name } }
    end
    assert_response :unprocessable_entity
  end
  test "duplicate email fails" do
    assert_difference "User.count", 0 do
      post registration_url, params: { user: { email_address: users(:one).email_address, password: "password", user_name: "test" } }
    end
    assert_response :unprocessable_entity
  end
  test "duplicate null email succeeds" do
    User.create(user_name: "test", password: "password", email_address: nil)
    assert_difference "User.count", 1 do
      post registration_url, params: { user: { email_address: nil, password: "password", user_name: "test2" } }
    end
  end
end
