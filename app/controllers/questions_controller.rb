class QuestionsController < ApplicationController
  def show

    @question = LearningObject.find(params[:id])
    rel = @question.seen_by_user(current_user.id)
    gon.userVisitedLoRelationId = rel.id

    if current_user.has_rooms?
      p "dnuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu"
      @next_question = @question.next_in_room(params[:room_number],@question.id)
      @previous_question = @question.previous_in_room(params[:room_number])

      @room = Room.find(params[:room_number])

      # Poradie zobrazenia danej otazky
      if current_user.show_solutions
        @number_of_question = @room.learning_objects.where("learning_object_id < ?",@question.id).count + 1
      else
        @number_of_question = @room.question_count - @room.question_count_not_visited
        @number_of_question +=1 if @room.not_answered(@question.id)
        p "aaaaaaaaaaaaaaaaaaa" + @number_of_question.to_s
      end
    else
      @next_question = @question.next(params[:week_number])
      @previous_question = @question.previous(params[:week_number])
    end

    @answers = @question.answers
    @relations = UserToLoRelation.where(learning_object_id: params[:id], user_id: current_user.id).group('type').count

    if current_user.show_solutions
      UserViewedSolutionLoRelation.create(user_id: current_user.id, learning_object_id: params[:id], setup_id: 1, )
      solution = @question.get_solution(current_user.id)
      gon.show_solutions = TRUE
      gon.solution = solution
    end

    @feedbacks = @question.feedbacks.visible.includes(:user)

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

    if current_user.has_rooms?
      room = Room.find(params[:room_number])
      rel = UserToLoRelation.new(setup_id: setup_id, user_id: user_id, room_id: params[:room_number], number_of_try: room.number_of_try)

      score_for_question = Levels::ScoreCalculation.compute_score_for_question(room,params,current_user) unless room.state.to_s == "used"
      room.update!(score: (room.score + score_for_question)) unless score_for_question.nil?
    else
      rel = UserToLoRelation.new(setup_id: setup_id, user_id: user_id)
    end

    if params[:commit] == 'send_answer'
      result = lo.right_answer?(params[:answer], @solution)
      @eval = true # informacie pre js odpoved
      rel.interaction = params[:answer]
    end

    rel.type = 'UserDidntKnowLoRelation' if params[:commit] == 'dont_know'
    rel.type = 'UserSolvedLoRelation' if params[:commit] == 'send_answer' && result
    rel.type = 'UserFailedLoRelation' if params[:commit] == 'send_answer' && !result

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

    if current_user.has_rooms?
      room = Room.find_by_id(params[:room_number])
      if current_user.show_solutions
        # V rezime so zobrazovanim spravnych odpovedi su otazky zoradene podla id
        lo_id = params[:lo_id]
        los = room.learning_objects.where("learning_object_id > ?",lo_id).order(id: :asc).first
        if los.nil?
          los = room.learning_objects.order(id: :asc).first
        end
      else
        # V rezime bez zobrazovania spravnych odpovedi sa vyberie otazka, z tych, ktore este nevidel, resp. ak taka nie je tak nahodna z danej miestnosti
        los = room.get_not_visited_los.shuffle.first || room.learning_objects.shuffle.first
      end
      redirect_to action: "show", id: los.url_name, week_number: params[:week_number]
    else
      setup = Setup.take
      week = setup.weeks.find_by_number(params[:week_number])
      RecommenderSystem::Recommender.setup(current_user.id,week.id,nil)
      best = RecommenderSystem::HybridRecommender.new.get_best
      los = LearningObject.find(best[0])
      redirect_to action: "show", id: los.url_name
    end
  end
end
