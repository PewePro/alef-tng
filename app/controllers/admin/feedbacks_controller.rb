module Admin
  # Umoznuje spravovat vzdelavacie objekty.
  class FeedbacksController < BaseController

    #before_filter :get_course, only: [:index, :new, :create]

    # Ulozenie noveho komentara k vzdelavaciemu objektu..
    def create
      begin
        feedback = Feedback.find(params[:learning_object])
        feedback_params = params.require(:feedback).permit(:lo_id, :message)

        #@learning_object = @course.learning_objects.new(learning_object_params)
        #@learning_object.save!
        redirect_to edit_admin_learning_object_path(@learning_object), notice: 'AAAA'
      rescue ActiveRecord::RecordInvalid
        #flash[:notice] = t('global.texts.please_fill_in')
      end
    end

  end
end