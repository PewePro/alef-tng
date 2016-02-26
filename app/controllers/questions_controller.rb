class QuestionsController < ApplicationController
  def show
    @user = current_user
    user_id = @user.id

    @question = LearningObject.find(params[:id])
    rel = @question.seen_by_user(user_id)
    gon.userVisitedLoRelationId = rel.id
    @next_question = @question.next(params[:room_number],@question.id)
    @previous_question = @question.previous(params[:room_number])
    @room_number = params[:room_number]
    @week_number= params[:week_number]

    @room = Room.find(params[:room_number])

    @answers = @question.answers
    @relations = UserToLoRelation.where(learning_object_id: params[:id], user_id: user_id).group('type').count

    if @user.show_solutions
      UserViewedSolutionLoRelation.create(user_id: user_id, learning_object_id: params[:id], setup_id: 1, )
      solution = @question.get_solution(current_user.id)
      gon.show_solutions = TRUE
      gon.solution = solution
    end

    if !(current_user.show_solutions)
      if @room.answered(@question.id,@room.id)
        @number_of_question = @room.question_count - @room.question_count_not_visited(@room.id) + 1
      else
        @number_of_question = @room.question_count - @room.question_count_not_visited(@room.id)
      end
    else
      @number_of_question = @room.learning_objects.where("learning_object_id < ?",@question.id).count + 1
    end

    @feedbacks = @question.feedbacks.includes(:user)
  end

  def eval_question
    weight_solved = 5
    weight_failed = 2
    weight_dont_now = 1
    @setup = Setup.take
    @week = @setup.weeks.find_by_number(params[:week_number])

    room = Room.find(params[:room_number])

    lo_class = Object.const_get params[:type]
    lo = lo_class.find(params[:id])

    @results = UserToLoRelation.get_results_room(current_user.id,@week.id,params[:room_number], room.number_of_try)
    result = @results.find {|r| r["result_id"] == lo.id.to_s}
    unless result.nil?
      solved = result['solved']
      failed = result['failed']
      donotnow = result['donotnow']
    end
    p "BBBBBBBBBBBBBBBBBBBBBBBB"
    p solved
    p failed
    p donotnow

    room = Room.find(params[:room_number])

    if params[:commit] == 'send_answer'
      result = lo.right_answer? params[:answer], @solution
    end

    difficulty = lo.difficulty.to_s
    dif_value = 0.0
    importance = lo.importance.to_s
    imp_value = 0.0

    if difficulty.to_s == "trivial"
      dif_value = 0.01
    elsif difficulty.to_s == "easy"
      dif_value = 0.25
    elsif difficulty.to_s == "medium"
      dif_value = 0.5
    elsif difficulty.to_s == "hard"
      dif_value = 0.75
    elsif difficulty.to_s == "impossible"
      dif_value = 1
    else
      dif_value = 0.5
    end

    if importance.to_s == "1"
      imp_value = 0
    elsif importance.to_s == "2"
      imp_value = 0.5
    elsif importance.to_s == "3"
      imp_value = 1
    else
      imp_value = 0.5
    end

    dif_compute = 0.0
    results = Levels::Preproces.preproces_data(@setup)

    all = 0
    do_not_know_value = 0
    results.each do |r|
      if r[0][1].to_i == lo.id
        all +=1
        if r[1].to_i == 0
          do_not_know_value +=1
        end
      end
    end

    if all!= 0
      dif_compute = do_not_know_value.to_f / all.to_f
      dif_result = (dif_value + dif_compute) / 2.0
    else
      dif_result = dif_value
    end

    score = 0.0
    p "dif_value " + dif_value.to_s
    p "imp_value " + imp_value.to_s
    p "dif_compute " + dif_compute.to_s

    if (solved.nil? && failed.nil? && donotnow.nil?) || (solved==0 && failed==0 && donotnow==0)
      p "som dnukaaaa"
      if params[:commit] == 'dont_know'
        score = weight_dont_now * imp_value *dif_result
      elsif (params[:commit] == 'send_answer' and result)
        score = weight_solved * imp_value * dif_result
      elsif (params[:commit] == 'send_answer' and not result)
        score = weight_failed * imp_value * dif_result
      end
    end

    p "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    p score

    room.update_attribute(:score, (room.score + score).to_d)

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
    rel.type = 'UserSolvedLoRelation' if params[:commit] == 'send_answer' and result
    rel.type = 'UserFailedLoRelation' if params[:commit] == 'send_answer' and not result

    if room.state.to_s != "used"
      eval_question
    end

    lo.user_to_lo_relations << rel


  end

  def show_image
    lo = LearningObject.find(params[:id])
    send_data lo.image, :type => 'image/png', :disposition => 'inline'
  end

  def log_time
    unless params[:id].nil?
      rel = UserVisitedLoRelation.find(params[:id])
      if not rel.nil? and rel.user_id == current_user.id
        rel.update interaction: params[:time]
      end
    end
    render nothing: true
  end

  def next

    @room = Room.find_by_id(params[:room_number])

    if !(current_user.show_solutions)
      id_array = []
      @results=RoomsLearningObject.get_id_do_not_viseted(params[:room_number])
      @results.each do |r|
        id_array.push(r['learning_object_id'].to_i)
      end

      if (id_array.empty?)
        lo = @room.learning_objects.all.distinct
        lo.each do |l|
          id_array.push(l.id)
        end
      end

      los = @room.learning_objects.find(id_array[Random.rand(0..(id_array.count-1))])
    else
      lo_id = params[:lo_id]
      los = @room.learning_objects.where("learning_object_id > ?",lo_id).order(id: :asc).first
      if los.nil?
        los = @room.learning_objects.order(id: :asc).first
      end
    end

    redirect_to action: "show", id: los.url_name, week_number: params[:week_number]
  end
end
