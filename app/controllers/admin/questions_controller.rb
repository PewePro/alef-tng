module Admin
  class QuestionsController < ApplicationController

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
      @question = Question.new
    end

    # Ulozenie novej otazky.
    def create

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