class WeeksController < ApplicationController
  def show
    @setup = Setup.take
    @week = @setup.weeks.find_by_number(params[:week_number])
    @next_week = @week.next
    @previous_week = @week.previous
    @week_number = params[:week_number]
   # learning_objects = @week.learning_objects.all.distinct
   # @results = UserToLoRelation.get_results(current_user.id,@week.id)
    p "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
    if (@week.rooms.count == 0)
      p "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      p @week.id
      p current_user.id
      Levels::RoomsCreation.create(@week.id, current_user.id)
    end
    @rooms = @week.rooms
    @used = @rooms.where(state: "used").all.count

    if (@week.learning_objects.count % 10 == 0)
      @all = (@week.learning_objects.count / 10).to_i
    else
      @all = (@week.learning_objects.count / 10).to_i + 1
    end

  #  RecommenderSystem::Recommender.setup(current_user.id,@week.id)
  #  recommendations = RecommenderSystem::HybridRecommender.new.get_list

   # @sorted_los = Array.new
   # recommendations.each do |key, value|
   #   @sorted_los << learning_objects.find {|l| l.id == key}
   # end

   # @activity = Levels::EvaluationActivities.activity(@sorted_los.count,learning_objects, @user, @results)

    @user = current_user
  end

  def list
    @setup = Setup.take
    @weeks = @setup.weeks.order(number: :desc)
    @user = current_user
  end
end
