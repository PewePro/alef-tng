module Admin
  # Umoznuje spravovat vzdelavacie objekty.
  class FeedbacksController < BaseController

    #before_filter :get_course, only: [:index, :new, :create]

    # Ulozenie noveho komentara k vzdelavaciemu objektu..
    def create
      begin
        learning_object = LearningObject.find(params[:learning_object_id])
        learning_object.feedbacks.create!(
            {
                anonymous_teacher: params[:feedback][:anonymous_teacher] == "1",
                accepted: true,
                message: params[:feedback][:message],
                user: current_user,
                user_agent: request.env['HTTP_USER_AGENT'],
                accept: request.env['HTTP_ACCEPT']
            })
        redirect_to edit_admin_learning_object_path(learning_object, anchor: :feedbacks), notice: t('feedbacks.texts.created')
      rescue ActiveRecord::RecordInvalid
        flash[:notice] = t('global.texts.please_fill_in')
      end
    end

  end
end