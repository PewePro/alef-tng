class QuestionsController < ApplicationController
  def show
    user_id = 1
    user = User.find(user_id)

    @question = LearningObject.find(params[:id])
    @question.seen_by_user(user_id)
    @next_question = @question.next(params[:week_number])
    @previous_question = @question.previous(params[:week_number])

    @answers = @question.answers
    @relations = UserToLoRelation.where(learning_object_id: params[:id], user_id: user_id).group('type').count

    if user.show_solutions
      UserViewedSolutionLoRelation.create(user_id: user_id, learning_object_id: params[:id], setup_id: 1, )
      solution = @question.get_solution
      gon.show_solutions = TRUE
      gon.solution = solution
    end
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

    rel.type = 'UserDidntKnowLoRelation' if params[:commit] == 'dont_know'
    rel.type = 'UserSolvedLoRelation' if params[:commit] == 'send_answer' and result
    rel.type = 'UserFailedLoRelation' if params[:commit] == 'send_answer' and not result

    lo.user_to_lo_relations << rel

  end
end
