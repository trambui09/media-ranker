class ApplicationController < ActionController::Base

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
