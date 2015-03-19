class QuestionsController < ApplicationController
  def show
    @question = LearningObject.find(params[:id])
    @question.seen_by_user(1)
    @next_question = @question.next(params[:week_number])
    @previous_question = @question.previous(params[:week_number])

    @answers = @question.answers
    @relations = UserToLoRelation.where(learning_object_id: params[:id], user_id: 1).group('type').count
  end

  def evaluate

    unless ["SingleChoiceQuestion","MultiChoiceQuestion","EvaluatorQuestion"].include? params[:type]
      # Kontrola ci zasielany type je z triedy LO
      render nothing: true
      return false
    end

    lo_class = Object.const_get params[:type]
    @solution = lo_class.find(params[:id]).get_solution

    # ak je send answer tak skontroluj params[:answer]
    # inak zaloguj relations
  end
end
