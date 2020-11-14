class ApplicationController < ActionController::Base

  # before_action :require_login

  def current_user
    @current_user = User.find_by(id: session[:user_id])

    # unless @current_user
    #   # TODO: must be logged in to upvote
    #   flash[:error] = "You must be logged in to see this page"
    #   redirect_to root_path
    #   return
    # end
  end

  def require_login
    if current_user.nil?
      flash[:error] = "You must be logged in to see this page"
      redirect_to login_path
      return
    end
  end
end
