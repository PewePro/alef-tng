class RoomsController < ApplicationController
  def show
    @setup = Setup.take
    @week = @setup.weeks.find_by_number(params[:week_number])

    @room = Room.find_by_id(params[:room_number])

    if @room.defined == FALSE
      p "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      @room.update_attribute(:defined, TRUE)
    end

    @next_room = @room.next
    @previous_room = @room.previous


    @learning_objects = @room.learning_objects.all.distinct
    @results = UserToLoRelation.get_results(current_user.id,@week.id)

    #RecommenderSystem::Recommender.setup(current_user.id,@week.id)
    #recommendations = RecommenderSystem::HybridRecommender.new.get_list

    #@sorted_los = Array.new
    #recommendations.each do |key, value|
    #  @sorted_los << learning_objects.find {|l| l.id == key}
    #end

    #@activity = Levels::EvaluationActivities.activity(@sorted_los.count,learning_objects, @user, @results)

    @user = current_user
  end

  def eval
    @room = Room.find(params[:room_number])
    learning_objects = @room.learning_objects.all.distinct

    weight_comment = 3

    @value = @room.score_limit

    if @room.state.to_s != "used"
      score1 = 0

      learning_objects.each do |l|
        feedbacks = l.feedbacks
        feedbacks.each do |f|
          if f.user_id == current_user.id
            score1 = score1.to_f + weight_comment
          end
        end
      end

      @score = (@room.score + score1).to_d

      if (@room.score + score1 >= @value)
        @room.update_attribute(:score, (@room.score + score1).to_d)
      else
        @room.update_attribute(:score, 0.to_d)
      end

      @room.update_attribute(:defined, FALSE)
      @room.update_attribute(:number_of_try, (@room.number_of_try + 1) )
    else
      @score = @room.score
    end

    @next_room = nil
    @privious_room = nil
  end

  def new
    @setup = Setup.take
    @week = @setup.weeks.find_by_number(params[:week_number])
    @room = Room.find(params[:room_number])
    @room.update_attribute(:state, "used")

    p "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    p @week.id
    p current_user.id
    room_id = Levels::RoomsCreation.create(@week.id, current_user.id)

    @rooms = @week.rooms
    @done = @rooms.count - 1

    @user = current_user

    redirect_to action: "show",week_number: params[:week_number], room_number: room_id

  end


end
