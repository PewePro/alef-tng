class RoomsController < ApplicationController
  def show
    p current_user.show_solutions.to_s
    @setup = Setup.take
    @week = @setup.weeks.find_by_number(params[:week_number])

    @room = Room.find_by_id(params[:room_number])

    @next_room = @room.next(current_user.id,@week.id)
    @previous_room = @room.previous(current_user.id,@week.id)


    @learning_objects = @room.learning_objects.order(id: :asc).distinct
    @results = UserToLoRelation.get_results(current_user.id,@week.id)

    @user = current_user
  end

  def eval
    @setup = Setup.take
    @room = Room.find(params[:room_number])
    learning_objects = @room.learning_objects.all.distinct

    weight_comment = 3

    @value = @room.score_limit

    @week=Week.find_by_id(@room.week_id)

    if (@week.learning_objects.distinct.count % 10 == 0)
      @all = (@week.learning_objects.distinct.count / 10).to_i
    else
      @all = (@week.learning_objects.distinct.count / 10).to_i + 1
    end
    @count = @week.rooms.where("user_id = ?", current_user.id).count
    p "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    p @all
    p @count

    if @room.state.to_s != "used"
      score1 = 0

      learning_objects.each do |l|
        feedbacks = l.feedbacks
        order_to_comment = 0
        order_to_comment_of_user = 0
        feedbacks.each do |f|
          order_to_comment += 1
          if f.user_id == current_user.id
            order_to_comment_of_user += 1
            difficulty = l.difficulty.to_s
            dif_value = 0.0
            importance = l.importance.to_s
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

            all_questions = 0
            do_not_know_value = 0
            results.each do |r|
              if r[0][1].to_i == l.id
                all_questions +=1
                if r[1].to_i == 0
                  do_not_know_value +=1
                end
              end
            end

            if all_questions!= 0
              dif_compute = do_not_know_value.to_f / all_questions.to_f
              dif_result = (dif_value + dif_compute) / 2.0
            else
              dif_result = dif_value
            end
            score1 = score1.to_f + weight_comment * dif_result * imp_value * (0.9 ** order_to_comment) * (0.9 ** order_to_comment_of_user)
          end
        end
      end

      @score = (@room.score + score1).to_f
      p "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      p score1
      p @score.to_s


      if (@all <= @count && @room.score + score1 >= @value)
        @room.update_attribute(:state, "used")
      end

      if (@room.score + score1 >= @value)
        @room.update_attribute(:score, (@room.score + score1).to_d)
      else
        val = Levels::RoomsCreation.compute_limit(learning_objects.count,learning_objects,@setup)
        p "aaaaaaaaaaaannnnnbbbbbbbbbbbbbb"
        p val
        @room.update_attribute(:score_limit, val.to_d)
        @room.update_attribute(:score, 0.to_d)
      end
    else
      @room_for_open = @week.rooms.where("state = ?","do_not_use").first
      @score = @room.score
    end

    @room.update_attribute(:number_of_try, (@room.number_of_try + 1) )

    @next_room = nil
    @privious_room = nil
  end

  def new
    @setup = Setup.take
    @week = @setup.weeks.find_by_number(params[:week_number])
    @room = Room.find(params[:room_number])
    @room.update_attribute(:state, "used")

    room_id = Levels::RoomsCreation.create(@week.id, current_user.id)

    @rooms = @week.rooms
    @done = @rooms.count - 1
    @user = current_user

    redirect_to action: "show",week_number: params[:week_number], room_number: room_id

  end

end
