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
      # not needed anymore since we made perforn_login in test_helper
      # user_hash = {
      #     user: {
      #         username: "Testing Username"
      #     }
      # }

      # trick: need to say user = nil first because of scope issue
      user = nil

      expect {
        # post login_path, params: user_hash
        user = perform_login()
      }.must_differ "User.count", 1

      must_respond_with :redirect
      # find the user, actually did this in our perform_login method
      # user = User.find_by(username: user_hash[:user][:username])

      expect(user).wont_be_nil
      expect(session[:user_id]).must_equal user.id
      expect(user.username).must_equal "Grace Hopper"
    end

    it "can log in an existing user" do
      # Arrange, make a user already exist in DB
      user = User.create(username: "Vishaal" )

      # Assert, since that user exists, user.count won't change when we perform log_in
      expect{
        perform_login(user.username)
      }.wont_differ "User.count"

      # session should be set
      expect(session[:user_id]).must_equal user.id
    end
  end

  describe "logout" do
    it "can logout a logged in user" do
      # arrange, to test logout, you have to login first
      perform_login()
      expect(session[:user_id]).wont_be_nil
      # act
      post logout_path

      # assert, since we logged out, the session[:user_id] will be erased and be nil
      expect(session[:user_id]).must_be_nil

    end

  end

  # describe "current user" do
  #   it "can return the page if the user is logged in" do
  #     # arrange
  #     user = User.first
  #     login_data = {
  #         user: {
  #             username: user.username
  #         }
  #     }
  #
  #     post login_path, params: login_data
  #     expect(session[:user_id]).must_equal user.id
  #
  #     # act
  #     get current_user_path
  #
  #     must_respond_with :success
  #
  #   end
  #
  #   it "redirect us back if the user is not logged in" do
  #     # act
  #     get current_user_path
  #
  #     # assert
  #     must_respond_with :redirect
  #     expect(flash[:error]).must_equal "You must be logged in to see this page"
  #
  #   end
  # end


end
