class QuestionsController < ApplicationController
  def show

    @user = current_user
    @question = LearningObject.find(params[:id])
    rel = @question.seen_by_user(current_user.id)
    gon.userVisitedLoRelationId = rel.id
    @next_question = @question.next(params[:room_number],@question.id)
    @previous_question = @question.previous(params[:room_number])

    @room = Room.find(params[:room_number])

    @answers = @question.answers
    @relations = UserToLoRelation.where(learning_object_id: params[:id], user_id: current_user.id).group('type').count

    if @user.show_solutions
      UserViewedSolutionLoRelation.create(user_id: current_user.id, learning_object_id: params[:id], setup_id: 1, )
      solution = @question.get_solution(current_user.id)
      gon.show_solutions = TRUE
      gon.solution = solution
    end

    if @user.show_solutions
      @number_of_question = @room.learning_objects.where("learning_object_id < ?",@question.id).count + 1
    else
      @number_of_question = @room.question_count - @room.question_count_not_visited
      if @room.not_answered(@question.id)
        @number_of_question +=1
      end
    end

    @feedbacks = @question.feedbacks.visible.includes(:user)
  end

  def eval_question
    setup = Setup.take
    room = Room.find(params[:room_number])

    lo_class = Object.const_get params[:type]
    lo = lo_class.find(params[:id])

    results_used = UserToLoRelation.get_results_room(current_user.id,params[:week_number],params[:room_number], room.number_of_try,lo.id).try(:first)
    used = FALSE
    unless results_used.nil?
      used = results_used["solved"] != 0 || results_used["failed"] != 0 || results_used["donotnow"] != 0
    end

    room = Room.find(params[:room_number])

    if params[:commit] == 'send_answer'
      result = lo.right_answer? params[:answer], @solution
    end

    dif_result = lo.get_difficulty(setup)
    imp_value = lo.get_importance

    score = 0.0

    if lo.type == "EvaluatorQuestion"
      solution = lo.get_solution(current_user.id)
      rightness = 1 - ((solution - params[:answer].to_i).abs)/100
      score = ENV["WEIGHT_SOLVED"].to_i * rightness * imp_value * dif_result
    else
      if results_used.nil? || !used
        if params[:commit] == 'dont_know'
          score = ENV["WEIGHT_DONT_NOW"].to_i * imp_value *dif_result
        elsif (params[:commit] == 'send_answer' && result)
          score = ENV["WEIGHT_SOLVED"].to_i * imp_value * dif_result
        elsif (params[:commit] == 'send_answer' && !result)
          score = ENV["WEIGHT_FAILED"].to_i * imp_value * dif_result
        end
      end
    end

    room.update!(score: (room.score + score))

  end

  def evaluate

    unless ["SingleChoiceQuestion","MultiChoiceQuestion","EvaluatorQuestion"].include? params[:type]
      # Kontrola ci zasielany type je z triedy LO
      render nothing: true
      return false
    end

    lo_class = Object.const_get params[:type]
    lo = lo_class.find(params[:id])

    @solution = lo.get_solution(current_user.id)
    @user = current_user
    user_id = @user.id
    setup_id = 1

    room = Room.find(params[:room_number])

    rel = UserToLoRelation.new(setup_id: setup_id, user_id: user_id, room_id: params[:room_number], number_of_try: room.number_of_try)

    if params[:commit] == 'send_answer'
      result = lo.right_answer? params[:answer], @solution
      @eval = true # informacie pre js odpoved
      rel.interaction = params[:answer]
    end

    rel.type = 'UserDidntKnowLoRelation' if params[:commit] == 'dont_know'
    rel.type = 'UserSolvedLoRelation' if params[:commit] == 'send_answer' && result
    rel.type = 'UserFailedLoRelation' if params[:commit] == 'send_answer' && !result

    eval_question unless room.state.to_s == "used"

    lo.user_to_lo_relations << rel


  end

  def show_image
    lo = LearningObject.find(params[:id])
    send_data lo.image, :type => 'image/png', :disposition => 'inline'
  end

  def log_time
    unless params[:id].nil?
      rel = UserVisitedLoRelation.find(params[:id])
      if not rel.nil? && rel.user_id == current_user.id
        rel.update interaction: params[:time]
      end
    end
    render nothing: true
  end

  def next
    room = Room.find_by_id(params[:room_number])

    if current_user.show_solutions
      lo_id = params[:lo_id]
      los = room.learning_objects.where("learning_object_id > ?",lo_id).order(id: :asc).first
      if los.nil?
        los = room.learning_objects.order(id: :asc).first
      end
    else
      los_not_visited = room.get_dont_visited
      if los_not_visited.nil?
        los = room.learning_objects.shuffle.first
      else
        los = los_not_visited.shuffle.first
      end
    end

    redirect_to action: "show", id: los.url_name, week_number: params[:week_number]
  end
end
