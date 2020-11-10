require "test_helper"

describe UsersController do
  it "can get login_form" do
    get login_path

    must_respond_with :success
  end

  describe "logging in" do
    it "can login a new user" do
      user_hash = {
          user: {
              username: "Testing Username"
          }
      }

      expect {
        post login_path, params: user_hash
      }.must_differ "User.count", 1

      must_respond_with :redirect
      user = User.find_by(username: user_hash[:user][:username])

      expect(user).wont_be_nil
      expect(session[:user_id]).must_equal user.id
      expect(user.username).must_equal user_hash[:user][:username]
    end
  end


end
