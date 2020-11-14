require "test_helper"

describe UsersController do
  before do
    @user = users(:tram)
  end
  it "can get login_form" do
    get login_path

    must_respond_with :success
  end

  it "must get index" do
    get users_path

    must_respond_with :success


  end

  it "must get show" do
    get user_path(@user.id)
    must_respond_with :success

  end

  it "will give a 404 error for a nonexistence user" do

    get user_path(-1)

    must_respond_with :not_found
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

  describe "logout" do
    
  end

  # describe "current" do
  #   it "returns 200 OK for a logged-in user " do
  #     # Arrange
  #     perform_login
  #
  #     # Act
  #     get current_user_path
  #
  #     # Assert
  #     must_respond_with :success
  #   end
  # end


end
