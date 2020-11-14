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

  # TODO: move finding a logged in user to the application_controller.rb
  # def current
  #   @current_user = User.find_by(id: session[:user_id])
  #
  #   unless @current_user
  #     # TODO: must be logged in to upvote
  #     flash[:error] = "You must be logged in to see this page"
  #     redirect_to root_path
  #     return
  #   end
  # end

end
