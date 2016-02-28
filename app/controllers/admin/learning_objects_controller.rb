module Admin
  class LearningObjectsController < ApplicationController

    before_action :get_course, only: [:index, :new, :create]

    #TODO
    #authorize_resource :class => false

    # Zobrazenie zoznamu uloh.
    def index
      @questions = @course.learning_objects.eager_load(:answers)

      feedback_new_count = Feedback.where(accepted: nil).where.not(learning_object_id: nil).count
      feedback_all_aggs = Feedback.select("learning_object_id").group(:learning_object_id).count
      feedback_new_aggs = feedback_new_count > 0 ? Feedback.select("learning_object_id").where(accepted: nil).group(:learning_object_id).count : {}
      @feedbacks = {
          all_aggs: feedback_all_aggs,
          new_aggs: feedback_new_aggs,
          new_count: feedback_new_count
      }
    end

    # Vytvorenie novej otazky.
    def new
      @learning_object = LearningObject.new
    end

    # Ulozenie novej otazky.
    def create
      learning_object_params = params.require(:learning_object).permit(:lo_id, :quest_text, :type, :difficulty)
      @course.learning_objects.create(learning_object_params)
      redirect_to administration_path, notice: "Otázka bola úspešne vytvorená."
    end

    # Editacia otazky.
    def edit
      @learning_object = LearningObject.find_by_id(params[:question_id])
      @answers = @learning_object.answers
      @feedback_new_count = Feedback.where(accepted: nil).where.not(learning_object_id: nil).count
    end

    private
    def get_course
      begin
        @course = Course.find(params[:course])
      rescue ActiveRecord::RecordNotFound
        redirect_to administration_path
      end
    end

  end
end