class UsersController < ApplicationController

  # skip_before_action :require_login, except: [:current_user]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])

    if @user.nil?
      head :not_found
      return
    end
  end

  # OAuth action
  def create
    auth_hash = request.env["omniauth.auth"]

    user = User.find_by(uid: auth_hash[:uid], provider: auth_hash["provider"])

    if user # found in DB
      flash[:success] = "Logged in as returning user #{user.username}"
    else # not in DB, attempt to create new user
      user = User.build_from_github(auth_hash)

      if user.save # user was able to save
        flash[:success] = "Logged in a new user #{user.username}"
      else
        # Couldn't save the user for some reason. If we
        # hit this it probably means there's a bug with the
        # way we've configured GitHub. Our strategy will
        # be to display error messages to make future
        # debugging easier.
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
        return redirect_to root_path
      end
    end

    # If we get here, we have a valid user instance
    session[:user_id] = user.id
    return redirect_to root_path
  end

  def login_form
    @user = User.new
  end

  def login
    username = params[:user][:username]
    user = User.find_by(username: username)

    if user # existing user
      session[:user_id] = user.id
      flash[:success] = "Successfully logged in as existing user #{username}"
    else # new user "Successfully created new user testingcat with ID 874"
      user = User.create(username: username)
      session[:user_id] = user.id
      flash[:success] = "Successfully created new user #{username} with ID #{user.id}"
    end

    redirect_to root_path
    return
  end

  def logout
    session[:user_id] = nil
    flash[:success] = "Succesfully logged out"
    redirect_to root_path
    return
  end

  # another action to logout, but I'll keep the old one
  # def destroy
  #   session[:user_id] = nil
  #   flash[:success] = "Successfully logged out!"
  #
  #   redirect_to root_path
  # end

  # TODO: move finding a logged in user to the application_controller.rb
  def current
    @user = User.find_by(id: session[:user_id])

    if @user.nil?
      # TODO: must be logged in to upvote
      flash[:error] = "You must be logged in to see this page"
      redirect_to root_path
      return
    end
  end

end
