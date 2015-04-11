class UsersController < ApplicationController
  def toggle_show_solutions
    @user = current_user
    if params[:show_solutions] == "false"
      @user.update(show_solutions: FALSE)
    else
      @user.update(show_solutions: TRUE)
    end
  end

  def send_feedback
    feedback = Feedback.new(
        message: params[:message],
        user_id: current_user.id,
        user_agent: request.env['HTTP_USER_AGENT'],
        accept: request.env['HTTP_USER_ACCEPT'],
        url: request.env['HTTP_REFERER']
    )
    if feedback.save
      FeedbackMailer.new(feedback).deliver_now
    end
  end
end