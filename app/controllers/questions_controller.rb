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
    lo = lo_class.find(params[:id])
    @solution = lo.get_solution

    user_id = 1
    setup_id = 1

    rel = UserToLoRelation.new(setup_id: setup_id, user_id: user_id)

    if params[:commit] == 'send_answer'
      result = lo.right_answer? params[:answer], @solution
      @eval = true # informacie pre js odpoved
      rel.interaction = params[:answer]
    end

    rel.type = 'UserViewedSolutionLoRelation' if params[:commit] == 'show_solution'
    rel.type = 'UserDidntKnowLoRelation' if params[:commit] == 'dont_know'
    rel.type = 'UserSolvedLoRelation' if params[:commit] == 'send_answer' and result
    rel.type = 'UserFailedLoRelation' if params[:commit] == 'send_answer' and not result

    lo.user_to_lo_relations << rel

  end
end
