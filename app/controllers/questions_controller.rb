class QuestionsController < ApplicationController
  def show
    @user = current_user
    user_id = @user.id

    @question = LearningObject.find(params[:id])
    rel = @question.seen_by_user(user_id)
    gon.userVisitedLoRelationId = rel.id
    @next_question = @question.next(params[:week_number])
    @previous_question = @question.previous(params[:week_number])

    @answers = @question.answers
    @relations = UserToLoRelation.where(learning_object_id: params[:id], user_id: user_id).group('type').count

    if @user.show_solutions
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
    @solution = lo.get_solution current_user.id

    @user = current_user
    user_id = @user.id
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

  def show_image
    lo = LearningObject.find(params[:id])
    send_data lo.image, :type => 'image/png', :disposition => 'inline'
  end

  def log_time
    rel = UserVisitedLoRelation.find(params[:id])
    if not rel.nil? and rel.user_id == current_user.id
      rel.update interaction: params[:time]
    end
    render nothing: true
  end
end
