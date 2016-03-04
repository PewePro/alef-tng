class RoomsController < ApplicationController
  def show
    setup = Setup.take
    week = setup.weeks.find_by_number(params[:week_number])

    @room = Room.find_by_id(params[:room_number])

    @next_room = @room.next(current_user.id,week.id)
    @previous_room = @room.previous(current_user.id,week.id)

    @learning_objects = @room.learning_objects.order(id: :asc)
    @results = UserToLoRelation.get_results(current_user.id,week.id)

  end

  def eval
    setup = Setup.take
    @room = Room.find(params[:room_number])
    learning_objects = @room.learning_objects

    @score_limit = @room.score_limit
    week = Week.find_by_id(@room.week_id)

    @count_real = (week.learning_objects.distinct.count / ENV["NUMBER_LOS"].to_i).to_i
    unless (week.learning_objects.distinct.count % ENV["NUMBER_LOS"].to_i == 0)
      @count_real +=1
    end

    @count_actual = week.rooms.where("user_id = ? AND state = ?", current_user.id, "used").count

    if @room.state == "used"
      @room_for_open = week.rooms.where("state = ?","do_not_use").first
      @score = @room.score
    else
      @count_actual += 1

      score1 = 0.0
      learning_objects.eager_load(:feedbacks).where("feedbacks.visible = ?", true).each do |l|
        order_to_comment = 0
        order_to_comment_of_user = 0
        l.feedbacks.each do |f|
          order_to_comment += 1
          if f.user_id == current_user.id
            order_to_comment_of_user += 1

            dif_result = l.get_difficulty(setup)
            imp_value = l.get_importance

            score1 = score1 + ENV["WEIGHT_COMMENT"].to_i * dif_result * imp_value * (ENV["BASE_EXP_FUNCTION"].to_f ** order_to_comment) * (ENV["BASE_EXP_FUNCTION"].to_f ** order_to_comment_of_user)
          end
        end
      end

      @score = @room.score + score1

      if (@count_real <= @count_actual && @room.score + score1 >= @score_limit)
        @room.update!(state: "used")
      end

      if (@room.score + score1 >= @score_limit)
        @room.update!(score: (@room.score + score1))
      else
        val = Levels::RoomsCreation.compute_limit(learning_objects.count,learning_objects,setup)
        @room.update!(score_limit: val.to_f)
        @room.update!(score: 0.0)
      end
    end

    @room.update!(number_of_try: (@room.number_of_try + 1))

    @next_room = nil
    @previous_room = nil
  end

  def new
    setup = Setup.take
    week = setup.weeks.find_by_number(params[:week_number])
    room = Room.find(params[:room_number])
    if room.state == "used"
      redirect_to controller: "weeks", action: "show"
    else
      room.update!(state: "used")
      room_id = Levels::RoomsCreation.create(week.id, current_user.id)
      redirect_to action: "show", room_number: room_id
    end
  end

end
