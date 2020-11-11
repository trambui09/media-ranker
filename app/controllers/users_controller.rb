class UsersController < ApplicationController

  def show
    @user = User.find_by(username: params[:user][:username])

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
    # if session[:user_id]
    #   user = User.find_by(id: session[:user_id])
    #   unless user.nil?
    #     session[:user_id].nil?
    #     flash[:success] = "Goodbye #{user.username}"
    #   else
    #     session[:user_id] = nil
    #     flash[:error] = "Error Unknown User"
    #   end
    # else
    #   flash[:error] = "You must be logged in to logout"
    # end
    #
    # redirect_to root_path
  end

  def current
    @current_user = User.find_by(id: session[:user_id])

    unless @current_user
      # TODO: must be logged in to upvote
      flash[:error] = "You must be logged in to see this page"
      redirect_to root_path
      return
    end
  end


end
