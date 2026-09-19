require "test_helper"

class SignInVerificationFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Test Buyer",
      email: "signin.flow.#{SecureRandom.hex(4)}@gmail.com",
      password: "Password123!",
      password_confirmation: "Password123!",
      role: "buyer",
      location: "London",
      email_verified_at: Time.current
    )
  end

  test "login stores the generated sign in code in session and validates it" do
    post "/login", params: {
      user: {
        email: @user.email,
        password: "Password123!"
      }
    }

    assert_response :redirect
    assert_equal @user.id, session["pending_sign_in_id"].to_i
    assert_not_nil session["pending_sign_in_code"]

    code = session["pending_sign_in_code"]

    post "/sign_in_verification", params: { sign_in_code: code }

    assert_redirected_to products_path
    assert_nil session["pending_sign_in_id"]
    assert_nil session["pending_sign_in_code"]
  end

  test "sign in code is one-time use and cannot be reused" do
    # First login
    post "/login", params: {
      user: {
        email: @user.email,
        password: "Password123!"
      }
    }

    code = session["pending_sign_in_code"]

    # Use the code successfully
    post "/sign_in_verification", params: { sign_in_code: code }
    assert_redirected_to products_path

    # Logout to test reuse attempt
    post "/logout", params: {}, headers: { "Accept" => "text/vnd.turbo-stream.html, text/html, application/xhtml+xml" }

    # Try to use the same code again - should fail because it was marked as used
    post "/login", params: {
      user: {
        email: @user.email,
        password: "Password123!"
      }
    }

    session_code = session["pending_sign_in_code"]
    # The old code should not work anymore (it's been cleared from the user)
    post "/sign_in_verification", params: { sign_in_code: code }
    assert_response :unprocessable_entity
    assert_includes flash[:alert], "Invalid or expired code"
  end
end
