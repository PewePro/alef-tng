class UsersController < ApplicationController
  def toggle_show_solutions
    @user = current_user
    if params[:show_solutions] == "false"
      @user.update(show_solutions: FALSE)
    else
      @user.update(show_solutions: TRUE)
    end
  end
end