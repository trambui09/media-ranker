require "test_helper"

describe UsersController do
  before do
    @user = users(:tram)
  end
  # it "can get login_form" do
  #   get login_path
  #
  #   must_respond_with :success
  # end

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
  # we got rid of this action in controller
  # describe "logging in" do
  #   it "can login a new user" do
  #     # not needed anymore since we made perforn_login in test_helper
  #     # user_hash = {
  #     #     user: {
  #     #         username: "Testing Username"
  #     #     }
  #     # }
  #
  #     # trick: need to say user = nil first because of scope issue
  #     user = nil
  #
  #     expect {
  #       # post login_path, params: user_hash
  #       user = perform_login()
  #     }.must_differ "User.count", 1
  #
  #     must_respond_with :redirect
  #     # find the user, actually did this in our perform_login method
  #     # user = User.find_by(username: user_hash[:user][:username])
  #
  #     expect(user).wont_be_nil
  #     expect(session[:user_id]).must_equal user.id
  #     expect(user.username).must_equal "Grace Hopper"
  #   end
  #
  #   it "can log in an existing user" do
  #     # Arrange, make a user already exist in DB
  #     user = User.create(username: "Vishaal" )
  #
  #     # Assert, since that user exists, user.count won't change when we perform log_in
  #     expect{
  #       perform_login(user.username)
  #     }.wont_differ "User.count"
  #
  #     # session should be set
  #     expect(session[:user_id]).must_equal user.id
  #   end
  # end

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

  describe "auth_callback" do
    it "logs in an existing user and redirect to the root_path" do
      # Count the users, to make sure we're not (for example) creating
      # a new user every time we get a login request

      start_count = User.count

      # get user from the fixtures

      user = users(:tram)


      # Tell OmniAuth to use this user's info when it sees
      # an auth callback from github

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

      # Send a login request for that user
      # Note that we're using the named path for the callback, as defined
      # in the `as:` clause in `config/routes.rb`
      get omniauth_callback_path(:github)

      must_redirect_to root_path
      # Since we can read the session, check that the user ID was set as expected
      session[:user_id].must_equal user.id

      # should not have created a new user
      User.count.must_equal start_count
    end
    it "creates an account for new user and redirects to the root path " do
      start_count = User.count

      user = User.new(provider: "github", uid: 99999, name: "test_user", email: "test@user.com")

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      get omniauth_callback_path(:github)

      must_redirect_to root_path

      # Should have created a new user
      User.count.must_equal start_count + 1

      # The new user's ID should be set in the session
      # find the new user in the DB
      user = User.find_by(uid: user.uid, provider: user.provider)
      session[:user_id].must_equal user.id

    end
    # TODO: this test fails because we would need to add a validation for uid on user model
    # it "redirects to the login_route if given invalid user data for new user" do
    #   start_count = User.count
    #
    #   # create new user without the uid
    #   user = User.new(provider: "github", uid: nil , name: "test_user", email: "test@user.com")
    #
    #   OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
    #   get omniauth_callback_path(:github)
    #
    #   must_redirect_to root_path
    #
    #
    #   # find the new user in the DB
    #   user = User.find_by(uid: user.uid, provider: user.provider)
    #
    #   # Make sure the user is nil
    #   expect(user).must_equal nil
    #
    #   # Since we can read the session, check that the user ID was set as expected
    #   session[:user_id].must_equal nil
    #
    #   # Should *not* have created a new user
    #   User.count.must_equal start_count
    #
    # end
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
